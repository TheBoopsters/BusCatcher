import 'package:bus_catcher/models/bus_model.dart';
import 'package:bus_catcher/providers/bus_provider.dart';
import 'package:bus_catcher/widgets/iconBus_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemBusWidget extends StatefulWidget {
  final BusModel busData;
  const ItemBusWidget({Key? key, required this.busData}) : super(key: key);

  @override
  State<ItemBusWidget> createState() => _ItemBusWidgetState();
}

class _ItemBusWidgetState extends State<ItemBusWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
          bottom: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 10),
        child: ListTile(
          onTap: () {
            context.read<BusProvider>().selectBus(widget.busData);
          },
          leading: IconBusWidget(number: widget.busData.number),
          title: Text(widget.busData.name),
        ),
      ),
    );
  }
}
