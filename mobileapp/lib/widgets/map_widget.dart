import 'package:bus_catcher/providers/location_provider.dart';
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

  @override
  initState() {
    setCamera();
    super.initState();
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
                  return Container();
                  return GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      zoom: 15,
                      target: LatLng(position.latitude, position.longitude),
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
