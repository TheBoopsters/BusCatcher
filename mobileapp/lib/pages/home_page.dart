import 'package:bus_catcher/widgets/bottomsheetbus_widget.dart';
import 'package:bus_catcher/widgets/drawer_widget.dart';
import 'package:bus_catcher/widgets/map_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: getDrawer(context),
        //bottomSheet: const SafeArea(child: BottomSheetBusWidget()),
        body: SingleChildScrollView(
          child: Column(
            children: const [
              MapWidget(),
              BottomSheetBusWidget(),
            ],
          ),
        )
        //const SafeArea(child: MapWidget()),
        );
  }
}
