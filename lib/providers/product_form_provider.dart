import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Product product;


  ProductFormProvider( this.product );

 
 
    increaseAmount(){
     
      this.product.amount+=1;
        notifyListeners();
    }

    decreaseAmount(){
      if(this.product.amount<=0){
        return;
      }
      this.product.amount-=1;
      notifyListeners();
    }

  bool isValidForm() {


  

    return formKey.currentState?.validate() ?? false;
  }

}