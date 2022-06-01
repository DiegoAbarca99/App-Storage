// To parse this JSON data, do
//
//     final customer = customerFromMap(jsonString);

import 'dart:convert';

class Customer {
    Customer({
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

    factory Customer.fromJson(String str) => Customer.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Customer.fromMap(Map<String, dynamic> json) => Customer(
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
