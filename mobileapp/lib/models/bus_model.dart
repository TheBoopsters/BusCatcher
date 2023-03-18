class BusModel {
  int id;
  String name;
  String number;
  int routeId;
  BusModel(
      {required this.id,
      required this.name,
      required this.number,
      required this.routeId});

  BusModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        number = json['number'],
        routeId = json['route']['id'];
}
