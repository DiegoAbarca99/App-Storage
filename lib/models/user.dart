// To parse this JSON data, do
//
//     final userTable = userTableFromMap(jsonString);

import 'dart:convert';

class User {
    User({
      this.ownerName,
      this.kindBussines,
      this.bussinesName,
      this.direction,
      this.picture,
      this.totalSales,
      this.totalExpenses,
      this.utility
      
    });
    String? utility;
    String? totalSales;
    String? totalExpenses;
    String? ownerName;
    String? kindBussines;
    String? bussinesName;
    String? direction;
    String? picture;

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        kindBussines: json["KindBussines"],
        bussinesName: json["BussinesName"],
        ownerName: json["OwnerName"],
        direction:json["Direction"],
        picture: json["Picture"],
        utility: json["Utility"],
        totalSales:json["TotalSales"],
        totalExpenses: json["TotalExpenses"]

        
    );

    Map<String, dynamic> toMap() => {
        "KindBussines": kindBussines,
        "BussinesName": bussinesName,
        "OwnerName": ownerName,
        "Picture":picture,
        "Direction":direction,
        "Utility":utility,
        "TotalSales":totalSales,
        "TotalExpenses":totalExpenses,
        
    };
}
