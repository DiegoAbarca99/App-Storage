import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class SelectedTransaccion extends ChangeNotifier{

  

    Transaccion? _selectedTransaccion;

  

  Transaccion? get selectedTransaccion=>_selectedTransaccion;

  set selectedTransaccion(Transaccion? value){
    _selectedTransaccion=value;
    notifyListeners();
  }

}