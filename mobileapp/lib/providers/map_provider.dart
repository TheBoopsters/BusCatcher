import 'dart:async';

import 'package:bus_catcher/models/route_model.dart';
import 'package:bus_catcher/models/stop_model.dart';
import 'package:bus_catcher/providers/api_provider.dart';
import 'package:bus_catcher/providers/bus_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:ui' as ui;

class MapProvider extends ChangeNotifier {
  final Set<Marker> markers = {};
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
      markers.add(Marker(
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
      color: const Color.fromRGBO(180, 1, 29, 100),
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
        markers.add(marker);
        busPositions[webBusId] = marker.position;
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 1900));
        markers.removeWhere((element) {
          if (element.mapsId == MarkerId(markerId)) {
            return true;
          }
          return false;
        });
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
    for (var marker in markers) {
      if (marker.markerId == MarkerId(stopId.toString())) {
        controller!
            .animateCamera(CameraUpdate.newLatLngZoom(marker.position, 20));
        notifyListeners();
        break;
      }
    }
  }
}
