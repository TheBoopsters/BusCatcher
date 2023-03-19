import 'package:bus_catcher/pages/home_page.dart';
import 'package:bus_catcher/providers/api_provider.dart';
import 'package:bus_catcher/providers/bus_provider.dart';
import 'package:bus_catcher/providers/location_provider.dart';
import 'package:bus_catcher/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => BusProvider()),
    ChangeNotifierProvider(create: (context) => LocationProvider()),
    ChangeNotifierProvider(create: (context) => APIProvider()),
    ChangeNotifierProvider(create: (context) => MapProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Catcher',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(17, 17, 17, 1),
      ),
      home: const HomePage(wasPlayed: false),
    );
  }
}
