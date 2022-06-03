import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';


class BussinesFormProvider extends ChangeNotifier {

  GlobalKey<FormState> bussinesformKey = new GlobalKey<FormState>();

  Bussines? bussines;


  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  set isLoading( bool value ) {
    _isLoading = value;
    notifyListeners();
  }



  BussinesFormProvider( this.bussines );
  

  
  bool isValidBussinesForm() {

    return bussinesformKey.currentState?.validate() ?? false;
  }

}