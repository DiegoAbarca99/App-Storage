// To parse this JSON data, do
//
//     final supplier = supplierFromMap(jsonString);

import 'dart:convert';

class Supplier {
    Supplier({
        this.cellPhone,
        this.comments,
        this.document,
        this.kindDocument,
        this.name,
    });

    int cellPhone;
    String comments;
    String document;
    String kindDocument;
    String name;

    factory Supplier.fromJson(String str) => Supplier.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Supplier.fromMap(Map<String, dynamic> json) => Supplier(
        cellPhone: json["CellPhone"],
        comments: json["Comments"],
        document: json["Document"],
        kindDocument: json["KindDocument"],
        name: json["Name"],
    );

    Map<String, dynamic> toMap() => {
        "CellPhone": cellPhone,
        "Comments": comments,
        "Document": document,
        "KindDocument": kindDocument,
        "Name": name,
    };
}
