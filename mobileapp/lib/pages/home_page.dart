import 'package:bus_catcher/widgets/bottomsheetbus_widget.dart';
import 'package:bus_catcher/widgets/drawer_widget.dart';
import 'package:bus_catcher/widgets/map_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final bool wasPlayed;
  const HomePage({Key? key, required this.wasPlayed}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              content: Text(
                  "Welcome to Bus Catcher, the ultimate real-time bus tracking app in Targu Mures!\n\nWith Bus Catcher, you can easily see the location of all buses in the city, in real-time.\n\nWhether you're commuting to work or school, Bus Catcher can help you catch your bus on time and avoid unneccessary delays.\n\nTo get started, simply swipe up and choose the bus of your choice!\n\nHappy commuting!"),
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.wasPlayed) {
      Future.delayed(Duration.zero, () => showAlert(context));
    }
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
