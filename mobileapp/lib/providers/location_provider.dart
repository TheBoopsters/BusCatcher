import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  static LocationSettings locationSettings =
      const LocationSettings(accuracy: LocationAccuracy.bestForNavigation);

  Future getPermission() async {
    //await Geolocator.openAppSettings();
    //await Geolocator.openLocationSettings();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanetly denied");
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    await getPermission();
    return await Geolocator.getCurrentPosition();
  }

  getLiveLocation() {
    Geolocator.getPositionStream(locationSettings: locationSettings);
  }
}
