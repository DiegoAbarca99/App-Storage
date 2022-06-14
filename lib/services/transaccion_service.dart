
import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;


class TransaccionsService extends ChangeNotifier{
  late String? userToken;
  late String? bussinesToken;

  final String _baseUrl='storage-app-c9bb6-default-rtdb.firebaseio.com';

  final List<Transaccion> transaccions=[];
  final List<Transaccion> transaccionsSearch=[];
  bool isLoading=true;
  bool isSaving=false;
  bool isDeleting=false;
  late Transaccion selectedTransaccion;
  final storage=FlutterSecureStorage();
 
  
  TransaccionsService({this.userToken,this.bussinesToken}){
    this.loadTransaccions();
  }

  Future loadTransaccions() async{

    transaccions.clear();

    isLoading=true;
    notifyListeners();


   final url= Uri.https(_baseUrl,'$userToken/Bussineses/$bussinesToken/Transaccions.json',{
     'auth':await storage.read(key: 'token')??''
   });
   final resp= await http.get(url);

   final Map <String,dynamic>? transaccionsMap=json.decode(resp.body);

   print('Respuesta: `${resp.body}`');
    transaccionsMap==null?null:
    transaccionsMap.forEach((key,value){//Parsea el mapa que posee un key exterior y a cada uno se le asigna un objeto del tipo producto
     final tempTransaccion=Transaccion.fromMap(value);
     tempTransaccion.id=key;
     transaccions.add(tempTransaccion);
   });

   isLoading=false;
   notifyListeners();


  }

  Future saveOrCreateTransaccion(Transaccion transaccion)async{
    isSaving=true;
    notifyListeners();

    if(transaccion.id==null){
     await createTransaccion(transaccion);

    }else{
      await updateTransaccion(transaccion);

    }


    isSaving=false;
    notifyListeners();
    
  }

  Future<String> updateTransaccion(Transaccion transaccion) async{

      print("Impresion del bussinesToken antes de actualizar la transaccion: $bussinesToken");
    
   final url= Uri.https(_baseUrl,'$userToken/Bussineses/$bussinesToken/Transaccions/${transaccion.id}.json',{
     'auth':await storage.read(key: 'token')??''
   });
   final resp= await http.put(url,body: transaccion.toJson());
   final decodeData=resp.body;
   print(resp.body);

    transaccions.forEach((element) {
      if(element.id==transaccion.id){
        element.concept=transaccion.concept;
        element.paymentMethod=transaccion.paymentMethod;
        element.type=transaccion.type;
        element.value=transaccion.value;

      }else{
        return;
      }
      

    });

  print("Se ha actualizado la transacción con id:${transaccion.id!}");
   return transaccion.id!;

  }

  
  Future<String> createTransaccion(Transaccion transaccion) async{

    print("Impresion del bussinesToken antes de crear la transaccion: $bussinesToken");
    
   final url= Uri.https(_baseUrl,'$userToken/Bussineses/$bussinesToken/Transaccions.json',{
     'auth':await storage.read(key: 'token')??''
   });
   final resp= await http.post(url,body: transaccion.toJson());
   final decodeData=json.decode(resp.body);

   transaccion.id=decodeData['name'];
   transaccions.add(transaccion);
   print(resp.body);

    
  print("Se ha creado una transaccion!!!!!!!");

   return transaccion.id!;

  }


  Future deleteTransaccion(Transaccion transaccion) async{
    isDeleting=true;
    notifyListeners();


    final url= Uri.https(_baseUrl,'$userToken/Bussineses/$bussinesToken/Transaccions/${transaccion.id}.json',{
     'auth':await storage.read(key: 'token')??''
   });


     final resp=  await http.delete(url);
      print('Resp delete:`${resp.body}`');

    isDeleting=false;

    //  products.remove(product);
      loadTransaccions();
    


  }





  Future<List<Transaccion>> searchTransaccions() async {



   final url= Uri.https(_baseUrl,'$userToken/Bussineses/$bussinesToken/Transaccions.json',{
     'auth':await storage.read(key: 'token')??''
   });
   final resp= await http.get(url);

   final Map <String,dynamic>? transaccionsMap=json.decode(resp.body);

   print('Respuesta del search: `${resp.body}`');
    transaccionsMap==null?null:
    transaccionsMap.forEach((key,value){//Parsea el mapa que posee un key exterior y a cada uno se le asigna un objeto del tipo producto
     final tempTransaccion=Transaccion.fromMap(value);
     tempTransaccion.id=key;
     transaccionsSearch.add(tempTransaccion);
   });

   return transaccionsSearch;

 
   

  }




}