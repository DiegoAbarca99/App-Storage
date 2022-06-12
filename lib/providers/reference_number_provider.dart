import 'package:flutter/material.dart';

class ReferenceNumberProvider extends ChangeNotifier {
 int _referenceNum=0;
 bool _isAdd=false;
 

   
  
  int get referenceNum=>_referenceNum;

 set  referenceNum(int value){
      _referenceNum=value;
      notifyListeners();
  }


 


  bool get isAdd=>_isAdd;

 set  isAdd(bool value){
      _isAdd=value;
      notifyListeners();
  }
  

  


}