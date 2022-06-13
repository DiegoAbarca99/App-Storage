

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;


class BussinesService extends ChangeNotifier{
  late String? userToken;

  final String _baseUrl='storage-app-c9bb6-default-rtdb.firebaseio.com';

  final List<Bussines> bussineses=[];
 
  bool isLoading=true;
  bool isSaving=false;
  bool isDeleting=false;

  

  final storage=FlutterSecureStorage();
  

   
  

  
  
  BussinesService({this.userToken}){
    this.loadBussineses();
  }

  Future loadBussineses() async{

    bussineses.clear();
    print("Cargando load bussineses");

    isLoading=true;
    notifyListeners();


   final url= Uri.https(_baseUrl,'$userToken/Bussineses.json',{
     'auth':await storage.read(key: 'token')??''
   });
   final resp= await http.get(url);

   final Map <String,dynamic>? bussinesesMap=json.decode(resp.body);

   print('Respuesta del load bussineses: `${resp.body}`');
   bussinesesMap==null?null:
   bussinesesMap.forEach((key,value){//Parsea el mapa que posee un key exterior y a cada uno se le asigna un objeto del tipo producto
     final tempBussines=Bussines.fromMap(value);
     tempBussines.id=key;
     bussineses.add(tempBussines);
   });


   

   isLoading=false;
   notifyListeners();




  }

  Future saveOrCreateBussines(Bussines bussines) async{
    print("Banderaaaaaa!!!!!!!!!!!!!!!!!!1");
    isSaving=true;
    notifyListeners();

    if(bussines.id==null){
     await createBussines(bussines);

    }else{
      await updateBussines(bussines);

    }


    isSaving=false;
    notifyListeners();
    
  }

  Future<String> updateBussines(Bussines bussines) async{
    
   final url= Uri.https(_baseUrl,'$userToken/Bussineses/${bussines.id}.json',{
     'auth':await storage.read(key: 'token')??''
   });
   final resp= await http.put(url,body: bussines.toJson());
   final decodeData=resp.body;
   print(resp.body);

      bussineses.forEach((element) {
      if(element.id==bussines.id){
        element.ownerName=bussines.ownerName;
        element.kindBussines=bussines.kindBussines;
        element.description=bussines.description;
        element.bussinesName=bussines.bussinesName;
        element.totalExpenses=bussines.totalExpenses;
        element.totalSales=bussines.totalSales;
        element.utility=bussines.utility;

      }else{
        return;
      }
      

    });

  print("Busiiness idd!!!!! ${bussines.id}");
   return bussines.id!;

  }

  
  Future<String> createBussines(Bussines bussines) async{
    
   final url= Uri.https(_baseUrl,'$userToken/Bussineses.json',{
     'auth':await storage.read(key: 'token')??''
   });
   final resp= await http.post(url,body: bussines.toJson());
   final decodeData=json.decode(resp.body);

   bussines.id=decodeData['name'];
   bussineses.add(bussines);
   print(resp.body);

   

    

    print("Busiiness idd!!!!! ${bussines.id}");
   return bussines.id!;

  }


  Future deleteBussineses(Bussines bussines) async{
    isDeleting=true;
    notifyListeners();


    final url= Uri.https(_baseUrl,'$userToken/Bussineses/${bussines.id}.json',{
     'auth':await storage.read(key: 'token')??''
   });


     final resp=  await http.delete(url);
      print('Resp delete:`${resp.body}`');

    isDeleting=false;

    //  products.remove(product);
      loadBussineses();
    


  }
}