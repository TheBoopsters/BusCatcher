import 'package:bus_catcher/providers/bus_provider.dart';
import 'package:bus_catcher/widgets/bottomSheetBus_widget.dart';
import 'package:bus_catcher/widgets/drawer_widget.dart';
import 'package:bus_catcher/widgets/infoBus_widget.dart';
import 'package:bus_catcher/widgets/listBus_widget.dart';
import 'package:bus_catcher/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(context),
      bottomSheet: BottomSheetBusWidget(),
      body: SafeArea(child: MapWidget()),
    );
  }
}
