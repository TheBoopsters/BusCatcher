import 'package:bus_catcher/models/stop_model.dart';
import 'package:flutter/material.dart';

class StopBusWidget extends StatefulWidget {
  final StopModel stopModel;
  const StopBusWidget({Key? key, required this.stopModel}) : super(key: key);

  @override
  State<StopBusWidget> createState() => _StopBusWidgetState();
}

class _StopBusWidgetState extends State<StopBusWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Row(children: [
        const Icon(Icons.bus_alert, size: 25),
        const SizedBox(
          width: 15,
        ),
        Text(widget.stopModel.name),
      ]),
    );
  }
}
