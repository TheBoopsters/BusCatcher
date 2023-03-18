import 'package:bus_catcher/providers/bus_provider.dart';
import 'package:bus_catcher/widgets/infoBus_widget.dart';
import 'package:bus_catcher/widgets/listbus_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetBusWidget extends StatefulWidget {
  const BottomSheetBusWidget({Key? key}) : super(key: key);

  @override
  State<BottomSheetBusWidget> createState() => _BottomSheetBusWidgetState();
}

class _BottomSheetBusWidgetState extends State<BottomSheetBusWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top:
                  BorderSide(color: Theme.of(context).primaryColor, width: 3))),
      height: MediaQuery.of(context).size.height / 3,
      child: Consumer<BusProvider>(
        builder: (context, value, child) {
          return !value.isSelected()
              ? const ListBusWidget()
              : const InfoBusWidget();
        },
      ),
    );
  }
}
