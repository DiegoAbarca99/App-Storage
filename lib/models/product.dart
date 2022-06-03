// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

class Product {
    Product({
       required this.amount,
       required this.buyPrice,
       required this.name,
       this.picture,
       required this.sellPrice,
       this.qrCode,
       this.id,
       this.description,
       this.category
    }); 

    int amount;
    double? buyPrice;
    String name;
    String? picture;
    double? sellPrice;
    String? qrCode;
    String? id;
    String? description;
    String? category;

    factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Product.fromMap(Map<String, dynamic> json) => Product(
        amount: json["Amount"],
        buyPrice: json["BuyPrice"]== null ? null : json["BuyPrice"].toDouble(),
        name: json["Name"],
        picture: json["Picture"],
        sellPrice: json["SellPrice"]== null ? null : json["SellPrice"].toDouble(),
        qrCode: json["QRCode"],
        description: json["Description"],
        category: json["Category"]
    
    );

    Map<String, dynamic> toMap() => {
        "Amount": amount,
        "BuyPrice": buyPrice,
        "Name": name,
        "Picture": picture,
        "SellPrice": sellPrice,
        "QRCode": qrCode,
        "Description": description,
        "Category" : category,

    };


 Product copy()=>Product(
      name: this.name,
      picture:this.picture, 
      sellPrice:this.sellPrice,
      id: this.id, 
      amount: this.amount,
      buyPrice: this.buyPrice, 
      qrCode: this.qrCode, 
      description: this.description,
      category: this.category
       
       
      );







}



   