import 'package:bus_catcher/models/stop_model.dart';

class RouteModel {
  int id;
  String name;
  List<StopModel> listStop;
  String polyLine;
  RouteModel(
      {required this.id,
      required this.name,
      required this.listStop,
      required this.polyLine});

  RouteModel.fromJson({required Map json})
      : id = json['id'],
        name = json['name'],
        polyLine = json['polylines'],
        listStop = [] {
    for (var jsonStop in json['stops']) {
      listStop.add(StopModel.fromJson(json: jsonStop, routeId: id));
    }
  }
}
