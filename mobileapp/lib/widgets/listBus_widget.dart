import 'package:bus_catcher/models/bus_model.dart';
import 'package:bus_catcher/widgets/itemBus_widget.dart';
import 'package:flutter/material.dart';

class ListBusWidget extends StatefulWidget {
  const ListBusWidget({Key? key}) : super(key: key);

  @override
  State<ListBusWidget> createState() => _ListBusWidgetState();
}

class _ListBusWidgetState extends State<ListBusWidget> {
  BusModel example =
      BusModel(id: 0, name: "Testname", routeId: 0, number: "23AB");
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: ListView(
        children: [
          ItemBusWidget(busData: example),
          ItemBusWidget(busData: example),
          ItemBusWidget(busData: example),
          ItemBusWidget(busData: example),
          ItemBusWidget(busData: example),
          ItemBusWidget(busData: example),
          ItemBusWidget(busData: example),
          ItemBusWidget(busData: example),
          ItemBusWidget(busData: example),
        ],
      ),
    );
  }
}
