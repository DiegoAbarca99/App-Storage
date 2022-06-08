import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppBackground extends StatelessWidget {

  final  Widget widget;
  const AppBackground({Key? key,required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;

    return Container(
      alignment: AlignmentDirectional.bottomEnd,
      width: double.infinity,
      height: size.height*0.4,
      child: this.widget
    );
  }
}