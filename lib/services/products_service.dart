

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;


class ProductsService extends ChangeNotifier{
  late String? userToken;

  final String _baseUrl='storage-app-c9bb6-default-rtdb.firebaseio.com';

  final List<Product> products=[];
  bool isLoading=true;
  bool isSaving=false;
  bool isDeleting=false;
  late Product selectedProduct;
  File? newPictureFile;
  final storage=FlutterSecureStorage();



  
  
  ProductsService({this.userToken}){
    this.loadProducts();
  }

  Future loadProducts() async{

    products.clear();

    isLoading=true;
    notifyListeners();


   final url= Uri.https(_baseUrl,'$userToken/Products.json',{
     'auth':await storage.read(key: 'token')??''
   });
   final resp= await http.get(url);

   final Map <String,dynamic>? productsMap=json.decode(resp.body);

   print('Respuesta: `${resp.body}`');
    productsMap==null?null:
   productsMap.forEach((key,value){//Parsea el mapa que posee un key exterior y a cada uno se le asigna un objeto del tipo producto
     final tempProduct=Product.fromMap(value);
     tempProduct.id=key;
     products.add(tempProduct);
   });

   isLoading=false;
   notifyListeners();


  }

  Future saveOrCreateProduct(Product product) async{
    isSaving=true;
    notifyListeners();

    if(product.id==null){
     await createProduct(product);

    }else{
      await updateProduct(product);

    }


    isSaving=false;
    notifyListeners();
    
  }

  Future<String> updateProduct(Product product) async{
    
   final url= Uri.https(_baseUrl,'$userToken/Products/${product.id}.json',{
     'auth':await storage.read(key: 'token')??''
   });
   final resp= await http.put(url,body: product.toJson());
   final decodeData=resp.body;
   print(resp.body);

    products.forEach((element) {
      if(element.id==product.id){
        element.name=product.name;
        element.category=product.category;
        element.description=product.description;
        element.sellPrice=product.sellPrice;
        element.buyPrice=product.buyPrice;
        element.picture=product.picture;
        element.qrCode=product.qrCode;
        element.amount=product.amount;

      }else{
        return;
      }
      

    });


   return product.id!;

  }

  
  Future<String> createProduct(Product product) async{
    
   final url= Uri.https(_baseUrl,'$userToken/Products.json',{
     'auth':await storage.read(key: 'token')??''
   });
   final resp= await http.post(url,body: product.toJson());
   final decodeData=json.decode(resp.body);

   product.id=decodeData['name'];
   products.add(product);
   print(resp.body);

    


   return product.id!;

  }


  Future deleteProduct(Product product) async{
    isDeleting=true;
    notifyListeners();


    final url= Uri.https(_baseUrl,'$userToken/Products/${product.id}.json',{
     'auth':await storage.read(key: 'token')??''
   });


     final resp=  await http.delete(url);
      print('Resp delete:`${resp.body}`');

    isDeleting=false;

    //  products.remove(product);
      loadProducts();
    


  }


  void upDateSelectedProductImage(String path){
      selectedProduct.picture=path;
      newPictureFile=File.fromUri(Uri(path: path));
      notifyListeners();
  }

  Future<String?> uploadImage() async{
    if(newPictureFile==null) return null;

    isSaving=true;
    notifyListeners();

    final url=Uri.parse('https://api.cloudinary.com/v1_1/dgrc6msan/image/upload?upload_preset=Flutter',);

    final imageUploadRequest=http.MultipartRequest('POST',url);
    final file=await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse=await imageUploadRequest.send();
    final resp=await http.Response.fromStream(streamResponse);

    if(resp.statusCode!=200&&resp.statusCode!=201){
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    newPictureFile=null;

    final decodeData=json.decode(resp.body);
    return decodeData['secure_url'];

  }

}