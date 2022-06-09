import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class SelectedProduct extends ChangeNotifier{

  

    Product? _selectedProduct;

  

  Product? get selectedProduct=>_selectedProduct;

  set selectedProduct(Product? value){
    _selectedProduct=value;
    notifyListeners();
  }

}