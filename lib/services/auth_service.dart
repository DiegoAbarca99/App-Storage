import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:productos_app/models/models.dart';

class AuthService extends ChangeNotifier{

  final String _baseUrl='identitytoolkit.googleapis.com';
  final String _firebaseToken='AIzaSyAvvGXo9mnsKvHc83N-CVfFvazra0B7C2g';
  String? _userToken;
  final storage=FlutterSecureStorage();


  bool _firsTime=false;


  bool get firsTime=>_firsTime;

  set firsTime(bool value){
    _firsTime=value;
    // notifyListeners();
    }



   String? get userToken=>_userToken;

  set userToken(String? value){
      _userToken=value;
      notifyListeners();
  }

  Future<String> createUser(String email,String password) async{
    final Map<String,dynamic> authData={
      'email':email,
      'password':password,
      'returnSecureToken':true
    };

    final url=Uri.https(_baseUrl,'/v1/accounts:signUp',{
      'key':_firebaseToken,
    }
    );

    final resp=await http.post(url,body: json.encode(authData));
    final Map<String,dynamic> decodeResp=json.decode(resp.body);

 

    if(decodeResp.containsKey('idToken')){
      await storage.write(key: 'token', value: decodeResp['idToken']);
      return decodeResp['email'];
    }else{
      return decodeResp['error']['message'];
    }

  }


  Future<String?> login(String email,String password) async{
    final Map<String,dynamic> authData={
      'email':email,
      'password':password,
      'returnSecureToken':true
    };

    final url=Uri.https(_baseUrl,'/v1/accounts:signInWithPassword',{
      'key':_firebaseToken,
    }
    );

    final resp=await http.post(url,body: json.encode(authData));
    final Map<String,dynamic> decodeResp=json.decode(resp.body);

    if(decodeResp.containsKey('idToken')){
      
      await storage.write(key: 'token', value: decodeResp['idToken']);
      return decodeResp['email'];
    }else{
      return decodeResp['error']['message'];
    }
    print(decodeResp);
  }


   Future deleteUser() async{

     final Map<String,String?> data={
        'idToken':await readToken(),
     };

      final url=Uri.https(_baseUrl,'/v1/accounts:delete',{
      'key':_firebaseToken,
      });

    final resp=  await http.post(url,body:json.encode(data));

    print(resp.body);

    await storage.delete(key: 'token');
  
  }


  Future logout() async{
    await storage.delete(key: 'token');
    
    return;
  }

  Future<String> readToken()async{
    return await storage.read(key: 'token')??'';
  }
}