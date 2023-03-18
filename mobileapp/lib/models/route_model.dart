import 'package:bus_catcher/models/stop_model.dart';

class RouteModel {
  int id;
  String name;
  List<StopModel> listStop;
  RouteModel({required this.id, required this.name, required this.listStop});

  RouteModel.fromJson({required Map json})
      : id = json['id'],
        name = json['name'],
        listStop = [] {
    for (var jsonStop in json['stops']) {
      listStop.add(StopModel.fromJson(json: jsonStop, routeId: id));
    }
  }
}
