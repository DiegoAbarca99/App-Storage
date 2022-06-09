import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class SelectedBussinesProvider extends ChangeNotifier {
  

    Bussines? _selectedBussines;

 
  

  Bussines? get selectedBussines=>_selectedBussines;

  set selectedBussines(Bussines? value){
    _selectedBussines=value;
    notifyListeners();
  }

  
  }
