import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';


class TransaccionFormProvider extends ChangeNotifier {

  GlobalKey<FormState> transaccionformKey = new GlobalKey<FormState>();

  Transaccion? transaccion;


  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  set isLoading( bool value ) {
    _isLoading = value;
    notifyListeners();
  }



  TransaccionFormProvider( this.transaccion );
  

  
  bool isValidTrasaccionForm() {

    return transaccionformKey.currentState?.validate() ?? false;
  }

}