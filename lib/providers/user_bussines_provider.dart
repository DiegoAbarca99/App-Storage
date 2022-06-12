import 'package:flutter/material.dart';

class UserBussinesProvider extends ChangeNotifier{

  

    String? _selectedUserBussines;

  

  String? get selectedUserBussines=>_selectedUserBussines;

  set selectedUserBussines(String? value){
    _selectedUserBussines=value;
    notifyListeners();
  }

}