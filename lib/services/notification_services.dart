import 'package:flutter/material.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey=new GlobalKey<ScaffoldMessengerState>();

  static ShowSnackBar(String message){
    final snackBar=new SnackBar(
      backgroundColor:Colors.red,

      content: Container(
        height:20,
        alignment: AlignmentDirectional.center,
        child: Text(message,style: TextStyle(color:Colors.white,fontSize: 20),))

    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }


}