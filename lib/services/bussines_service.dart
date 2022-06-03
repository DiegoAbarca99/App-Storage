import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class BussinesService extends ChangeNotifier {


final String _baseUrl='storage-app-c9bb6-default-rtdb.firebaseio.com';
bool isLoading=true;
bool isSaving=false;
bool isDeleting=false;
final List<Bussines> bussineses=[];
late final Bussines? selectedBussines;
final storage=FlutterSecureStorage();

late String? userToken;

  
  BussinesService({this.userToken}){
    //this.loadProducts();
  }

  Future loadBussineses() async{

    bussineses.clear();

    isLoading=true;
    notifyListeners();


   final url= Uri.https(_baseUrl,'$userToken/Bussineses.json',{
     'auth':await storage.read(key: 'token')??''
   });
   final resp= await http.get(url);

   final Map <String,dynamic>? bussinesesMap=json.decode(resp.body);

   print('Respuesta del Bussineses service: `${resp.body}`');
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
  

    bussineses.forEach((element) {
      if(element.id==bussines.id){
        element.utility=bussines.utility;
        element.totalSales=bussines.totalExpenses;
        element.direction=bussines.direction;
        element.ownerName=bussines.ownerName;
        element.totalExpenses=bussines.totalExpenses;
        element.description=bussines.description;
        element.bussinesName=bussines.bussinesName;
        element.kindBussines=bussines.kindBussines;


      }else{
        return;
      }
      

    });


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

    


   return bussines.id!;

  }


  Future deleteBussines(Bussines bussines) async{
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



