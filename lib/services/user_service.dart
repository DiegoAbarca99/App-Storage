import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class UserService extends ChangeNotifier {


final String _baseUrl='storage-app-c9bb6-default-rtdb.firebaseio.com';
bool isLoading=true;
bool isSaving=false;
final List<User> users=[];
late final User? selectedUser;
final storage=FlutterSecureStorage();
bool _firsTime=false;


bool get firsTime=>_firsTime;

set firsTime(bool value){
  _firsTime=value;
 // notifyListeners();
}




}



