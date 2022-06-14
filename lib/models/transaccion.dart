// To parse this JSON data, do
//
//     final transaccion = transaccionFromMap(jsonString);

import 'dart:convert';

class Transaccion {
    Transaccion({
        this.concept,
        this.paymentMethod,
       required  this.type,
       required this.value,
       this.id,
       required this.amount
    });

    String? concept;
    String? paymentMethod;
    String type;
    double value;
    String? id;
    int amount;

    factory Transaccion.fromJson(String str) => Transaccion.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Transaccion.fromMap(Map<String, dynamic> json) => Transaccion(
        concept: json["Concept"],
        paymentMethod: json["PaymentMethod"],
        type: json["Type"],
        value: json["Value"]== null ? null : json["Value"].toDouble(),
        amount:json["Amount"],
    );

    Map<String, dynamic> toMap() => {
        "Concept": concept,
        "PaymentMethod": paymentMethod,
        "Type": type,
        "Value": value,
        'Amount':amount
    };

    Transaccion copy()=>Transaccion(
      concept: this.concept,
      value:this.value,
      type:this.type,
      paymentMethod: this.paymentMethod,
      id: this.id,
      amount: this.amount
    );

    
}

