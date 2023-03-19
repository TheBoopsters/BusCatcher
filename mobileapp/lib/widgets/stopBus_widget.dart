import 'package:bus_catcher/models/stop_model.dart';
import 'package:bus_catcher/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StopBusWidget extends StatefulWidget {
  final StopModel stopModel;
  const StopBusWidget({Key? key, required this.stopModel}) : super(key: key);

  @override
  State<StopBusWidget> createState() => _StopBusWidgetState();
}

class _StopBusWidgetState extends State<StopBusWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
        bottom: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
      )),
      child: ListTile(
        onTap: () {
          context.read<MapProvider>().highLightMarker(widget.stopModel.id);
        },
        title: Row(children: [
          const Icon(Icons.bus_alert, size: 25),
          const SizedBox(
            width: 15,
          ),
          Text(widget.stopModel.name),
        ]),
      ),
    );
  }
}
