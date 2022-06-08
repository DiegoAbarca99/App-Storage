import 'package:flutter/material.dart';

class IventoryScreen extends StatelessWidget {
  const IventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size=MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [

          Container(
            color: Colors.red,
             width: double.infinity,
             height: size.height * 0.4,
            decoration: BoxDecoration(
              
              
              
            ),
          )

        ],),
    );
  }
}