import 'package:bus_catcher/models/stop_model.dart';

class RouteModel {
  int id;
  String name;
  List<StopModel> listStop;
  RouteModel({required this.id, required this.name, required this.listStop});
}
