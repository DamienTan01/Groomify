import 'package:flutter/material.dart';

//Manage the state of selected services
//Provider class will keep track of the selected state and provide methods for updating it.
class SelectedServicesProvider extends ChangeNotifier {
  List<bool> selectedServiceStates = List.generate(8, (index) => false);

  void toggleServiceState(int index) {
    selectedServiceStates[index] = !selectedServiceStates[index];
    notifyListeners();
  }
}
