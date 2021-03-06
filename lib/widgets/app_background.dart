import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppBackground extends StatelessWidget {

  final  Widget widget;
  const AppBackground({Key? key,required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;

    return Container(
      decoration: _buildBoxDecoration(),
      alignment: AlignmentDirectional.bottomEnd,
      width: double.infinity,
      height: size.height*0.3,
      child: this.widget
    );
  }
   BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(25),
       color: Colors.white,
       boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0,7),
            blurRadius: 10
        )
      ]
        
      );

  } 




}
