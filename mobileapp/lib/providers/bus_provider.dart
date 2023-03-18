import 'package:bus_catcher/models/bus_model.dart';
import 'package:flutter/material.dart';

class BusProvider extends ChangeNotifier {
  bool _isSelected = false;
  List<BusModel> listBus = [];
  BusModel? _busData;

  BusProvider();

  BusModel? getBus() {
    return _busData;
  }

  void selectBus(BusModel busData) {
    _busData = busData;
    _setSelected(true);
    notifyListeners();
  }

  void unselectBus() {
    _busData = null;
    _setSelected(false);
    notifyListeners();
  }

  void _setSelected(bool value) {
    _isSelected = value;
  }

  bool isSelected() {
    return _isSelected;
  }

  int getRouteId() {
    return _busData!.routeId;
  }
}
