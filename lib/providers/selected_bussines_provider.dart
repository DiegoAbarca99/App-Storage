import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class SelectedBussinesProvider extends ChangeNotifier {
  
    bool _isSelected=false;

    Bussines? _selectedBussines;

  bool get isSelected=>_isSelected;

  set isSelected(bool value){
    _isSelected=value;
    notifyListeners();
  }
  

  Bussines? get selectedBussines=>_selectedBussines;

  set selectedBussines(Bussines? value){
    _selectedBussines=value;
    notifyListeners();
  }


}