import 'package:bus_catcher/models/bus_model.dart';
import 'package:bus_catcher/providers/api_provider.dart';
import 'package:flutter/material.dart';

class BusProvider extends ChangeNotifier {
  bool _isSelected = false;
  BusModel? _busData;
  List<BusModel> busList = [];
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

  int getBusId() {
    return _busData!.id;
  }

  setBusList(busList) {
    this.busList = busList;
  }

  selectBusById(int id) {
    for (BusModel busData in busList) {
      if (busData.id == id) {
        _busData = busData;
        _isSelected = true;
        break;
      }
    }
    notifyListeners();
  }
}
