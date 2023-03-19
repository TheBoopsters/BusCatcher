import 'package:bus_catcher/providers/bus_provider.dart';
import 'package:bus_catcher/providers/location_provider.dart';
import 'package:bus_catcher/providers/map_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late final CameraPosition initialCameraPosition;
  late GoogleMapController mapController;
  @override
  initState() {
    setCamera();
    super.initState();
  }

  _onMapCreate(GoogleMapController controller) {
    mapController = controller;
    context.read<MapProvider>().controller = controller;
    context.read<MapProvider>().getBuses(context);
  }

  setCamera() async {
    context.read<LocationProvider>().getPermission();
    Position position =
        await context.read<LocationProvider>().getCurrentLocation();
    setState(() {
      initialCameraPosition =
          CameraPosition(target: LatLng(position.latitude, position.longitude));
    });
  }

  sendBusId(int selectedBus) {
    if (selectedBus != -1) {
      context.read<BusProvider>().selectBusById(selectedBus);
      context.read<MapProvider>().clearBusId();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Align(
            child: SafeArea(
              child: FutureBuilder(
                future: context.read<LocationProvider>().getCurrentLocation(),
                builder: (context, AsyncSnapshot<Position> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  Position? position = snapshot.data;
                  if (position == null) {
                    return Container();
                  }
                  /*StreamBuilder(
                    stream: context.read<LocationProvider>().getLiveLocation(),
                    builder: (context, snapshot) {},
                  );*/
                  return Consumer<MapProvider>(
                    builder: (context, value, child) {
                      sendBusId(value.selectedBus);
                      return GoogleMap(
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          zoom: 15,
                          target: LatLng(position.latitude, position.longitude),
                        ),
                        onMapCreated: (controller) => _onMapCreate(controller),
                        markers: value.markers,
                        polylines: value.polylines,
                        myLocationButtonEnabled: true,
                        gestureRecognizers: {}..add(
                            Factory<PanGestureRecognizer>(
                                () => PanGestureRecognizer())),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ));
  }
}
