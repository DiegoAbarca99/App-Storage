import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchBackground extends StatelessWidget {

  final  Widget widget;
  const SearchBackground({Key? key,required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;

    return Container(
      decoration: _buildBoxDecoration(),
      alignment: AlignmentDirectional.bottomEnd,
      width: double.infinity,
      height: double.infinity,
      child: this.widget
    );
  }
   BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
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
