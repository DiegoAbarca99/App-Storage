// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

class Product {
    Product({
       required this.available,
       required  this.name,
       this.picture,
       this.price,
       this.id
    });

    bool available;
    String name;
    String? picture;
    double? price;
    String? id;

    factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["Available"],
        name: json["Name"],
        picture: json["Picture"],
        price: json["Price"] == null ? null : json["Price"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "Available": available,
        "Name": name,
        "Picture": picture,
        "Price": price == null ? null : price,
    };

    Product copy()=>Product(
      available: this.available,
      name: this.name,
      picture:this.picture, 
      price:this.price,
      id: this.id    
      );

    

}
