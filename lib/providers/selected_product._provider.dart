import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class SelectedProduct extends ChangeNotifier{

    bool _isSelected=false;

    Product? _selectedProduct;

  bool get isSelected=>_isSelected;

  set isSelected(bool value){
    _isSelected=value;
    notifyListeners();
  }
  

  Product? get selectedProduct=>_selectedProduct;

  set selectedProduct(Product? value){
    _selectedProduct=value;
    notifyListeners();
  }

}