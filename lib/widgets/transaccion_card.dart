import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class TransaccionCard extends StatelessWidget {

     final Transaccion transaccion;

  const TransaccionCard({Key? key,required this.transaccion}) : super(key: key);

   


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
      child: Container(

        decoration: _buildBoxDecoration(),
        width: double.infinity,
        height: 100,
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal:10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(transaccion.concept!,style:Theme.of(context).textTheme.headline6,),

                  SizedBox(height: 5,),

                  transaccion.type=='loss'
                                    ?
                                    Text("\$ ${transaccion.value}",style: TextStyle(color: Colors.red))
                                    :
                                    Text("\$ ${transaccion.value}",style: TextStyle(color: Colors.green)),

                  SizedBox(height: 5),

                  Text("${transaccion.type}"),

                  
              ],),
              

              _TransaccionLogo(transaccion.type),
            ]),
        
      ),
     ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
       color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(25),
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


class _TransaccionLogo extends StatelessWidget {

  final String type;
 


  const _TransaccionLogo(this.type);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 50,
        height: 50,
        child:type=='Gain'
                        ?
                        Icon(Icons.monetization_on_outlined,color:Colors.green)
                        :
                        Icon(Icons.monetization_on_outlined,color:Colors.red)
         
      ),
    );
  }
}