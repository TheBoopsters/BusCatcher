import 'package:google_maps_flutter/google_maps_flutter.dart';

class StopModel {
  int id;
  int orderId;
  LatLng position;
  String name;
  int routeId;

  StopModel(
      {required this.id,
      required this.name,
      required this.orderId,
      required this.routeId,
      required this.position});
}
