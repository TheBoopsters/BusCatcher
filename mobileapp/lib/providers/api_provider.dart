import 'dart:async';
import 'dart:convert';

import 'package:bus_catcher/models/bus_model.dart';
import 'package:bus_catcher/models/route_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class APIProvider extends ChangeNotifier {
  static String busListLink = r"https://buscatcher.tohka.us/api/buses/";
  static String routeListLink = r"https://buscatcher.tohka.us/api/routes/";
  static String tokenLink = r"https://buscatcher.tohka.us/api/token/";
  static String webSocketLink = r"wss://buscatcher.tohka.us/ws";
  String? accessToken = null;
  Future<List<BusModel>> getBusList() async {
    Uri busListUri = Uri.parse(busListLink);
    List<BusModel> listBus = [];
    String httpPackageInfo = await http.read(busListUri);
    final httpPackageJson = json.decode(httpPackageInfo);
    for (var jsonBus in httpPackageJson) {
      listBus.add(BusModel.fromJson(jsonBus));
    }
    return listBus;
  }

  Future<RouteModel> getRoute(int routeId) async {
    String currentRouteLink = "$routeListLink$routeId";
    Uri currentRouteUri = Uri.parse(currentRouteLink);
    String httpPackageInfo = await http.read(currentRouteUri);
    final httpPackageJson = json.decode(httpPackageInfo);

    return RouteModel.fromJson(json: httpPackageJson);
  }

  login(String userName, String password) async {
    Uri currentTokenUri = Uri.parse(tokenLink);
    http.Response httpResponse = await http.post(currentTokenUri,
        body: {"username": userName, "password": password});
    if (httpResponse.statusCode == 200) {
      Map response = json.decode(httpResponse.body);
      accessToken = response["access"];
      return true;
    } else {
      return false;
    }
  }

  logout() {
    accessToken = null;
  }

  isLoggedIn() {
    if (accessToken != null) {
      return true;
    } else {
      return false;
    }
  }

  WebSocketChannel connectToWebSocket() {
    WebSocketChannel channel = WebSocketChannel.connect(
      Uri.parse(webSocketLink),
    );
    return channel;
  }
}
