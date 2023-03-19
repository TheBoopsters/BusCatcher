import 'dart:async';

import 'package:bus_catcher/models/route_model.dart';
import 'package:bus_catcher/models/stop_model.dart';
import 'package:bus_catcher/providers/api_provider.dart';
import 'package:bus_catcher/providers/bus_provider.dart';
import 'package:bus_catcher/providers/location_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class MapProvider extends ChangeNotifier {
  final Map<MarkerId, Marker> markers = {};
  final Set<Polyline> polylines = {};
  final List<LatLng> polylinesCoordinates = [];
  final Map<int, LatLng> busPositions = {};
  final PolylinePoints polylinePoints = PolylinePoints();
  int selectedBus = -1;
  StreamSubscription<Position>? streamSubscription;
  WebSocketChannel? webSocket;
  GoogleMapController? controller;

  int busId = -1;
  getMarkers(int busId, int routeId) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/busStation_marker.png', 95);
    RouteModel routeData = await APIProvider().getRoute(routeId);
    LatLng? position;
    LatLng? stopPosition;
    markers.clear();

    for (StopModel stop in routeData.listStop) {
      markers[MarkerId(stop.id.toString())] = (Marker(
          markerId: MarkerId(stop.id.toString()),
          position: stop.position,
          icon: BitmapDescriptor.fromBytes(markerIcon)));
      stopPosition = stop.position;
    }
    if (!busPositions.containsKey(busId)) {
      position = stopPosition;
    } else {
      position = busPositions[busId];
    }
    getPolyLines(routeData.polyLine);
    if (position != null) {
      controller!.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
    }
    notifyListeners();
  }

  getPolyLines(String encoded) async {
    var points = polylinePoints.decodePolyline(encoded);

    for (PointLatLng point in points) {
      polylinesCoordinates.add(LatLng(point.latitude, point.longitude));
    }

    polylines.add(Polyline(
      width: 10,
      polylineId: const PolylineId('polyLine'),
      color: const Color.fromRGBO(184, 37, 54, 100),
      points: polylinesCoordinates,
    ));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  getBuses(BuildContext context) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/bus_marker.png', 160);
    WebSocketChannel channel = APIProvider().connectToWebSocket();
    String markerId;
    channel.stream.listen((event) async {
      String str = event;
      List<String> values = str.split(';');
      markerId = values[0] + values[1];
      int webBusId = int.parse(values[1]);
      if (webBusId == busId || busId == -1) {
        Marker marker = Marker(
          markerId: MarkerId(markerId),
          position: LatLng(
            double.parse(values[2]),
            double.parse(values[3]),
          ),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () {
            context.read<BusProvider>().selectBusById(webBusId);
          },
        );
        markers[MarkerId(markerId)] = marker;
        busPositions[webBusId] = marker.position;
        notifyListeners();
      }
    });
  }

  sendLocation(Stream<Position> liveLocation, int busId, String accessToken) {
    if (accessToken.isEmpty) {
      return;
    }
    var webSocket = APIProvider().connectToWebSocket();
    this.webSocket = webSocket;
    streamSubscription = liveLocation.listen(
      (event) {
        webSocket.sink
            .add(APIProvider.messageToWebSocket(event, busId, accessToken));
      },
      onDone: () {
        webSocket.sink.close();
      },
    );
  }

  closeLiveLocation() async {
    if (streamSubscription == null) {
      return;
    }
    if (webSocket == null) {
      return;
    }
    await streamSubscription!.cancel();
  }

  setBusId(int id) {
    busId = id;
  }

  clearBusId() {
    busId = -1;
  }

  clearMarkers() {
    markers.clear();
    polylines.clear();
    notifyListeners();
  }

  highLightMarker(int stopId) {
    for (var marker in markers.values) {
      if (marker.markerId == MarkerId(stopId.toString())) {
        controller!
            .animateCamera(CameraUpdate.newLatLngZoom(marker.position, 20));
        notifyListeners();
        break;
      }
    }
  }

  calculateDistanceFromBus(int busId) async {
    double distanceToTimeNumber = 0.221;
    Position currentPosition = await LocationProvider().getCurrentLocation();
    double distance = getDistanceFromLatLonInKm(
        currentPosition.latitude,
        currentPosition.longitude,
        busPositions[busId]!.latitude,
        busPositions[busId]!.longitude);
    distance = distance.ceilToDouble();
    int time = (distance / distanceToTimeNumber).ceil();
    return "$distance km / $time minutes";
  }

  double getDistanceFromLatLonInKm(
      double lat1, double lon1, double lat2, double lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  double deg2rad(deg) {
    return deg * (math.pi / 180);
  }
}
