// To parse this JSON data, do
//
//     final userTable = userTableFromMap(jsonString);

import 'dart:convert';



class Bussines {
    Bussines({
      this.ownerName,
      this.kindBussines,
      this.bussinesName,
      this.direction,
      this.description,
      this.totalSales,
      this.totalExpenses,
      this.utility,
      this.id,
      
      
    });
   
    String? id;
    double? utility;
    double? totalSales;
    double? totalExpenses;
    String? ownerName;
    String? kindBussines;
    String? bussinesName;
    String? direction;
    String? description;

    factory Bussines.fromJson(String str) => Bussines.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Bussines.fromMap(Map<String, dynamic> json) => Bussines(
        kindBussines: json["KindBussines"],
        bussinesName: json["BussinesName"],
        ownerName: json["OwnerName"],
        direction:json["Direction"],
        utility: json["Utility"],
        totalSales:json["TotalSales"],
        totalExpenses: json["TotalExpenses"],
        description: json["Description"],
    

        
    );

    Map<String, dynamic> toMap() => {
        "KindBussines": kindBussines,
        "BussinesName": bussinesName,
        "OwnerName": ownerName,
        "Direction":direction,
        "Utility":utility,
        "TotalSales":totalSales,
        "TotalExpenses":totalExpenses,
        "Description":  description,

        
    };

    toString()=>"id: $id, ownerBussines: $ownerName";
}
