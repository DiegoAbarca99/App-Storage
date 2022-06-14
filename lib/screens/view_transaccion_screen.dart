import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

class ViewTransaccionScreen extends StatelessWidget {
  const ViewTransaccionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final list=ModalRoute.of(context)!.settings.arguments as List;
    final String bussinesToken=list[0];
    final ProductsService? productsService=list[1];
    final Product? selectedProduct =list[2];

    final authService=Provider.of<AuthService>(context);


    return ChangeNotifierProvider(

      create: (_) => TransaccionsService(userToken: authService.userToken,bussinesToken: bussinesToken),
      child: _ViewTransaccionScreenBody(productsService: productsService, selectedProduct: selectedProduct,bussinesToken: bussinesToken,));
  }
}

class _ViewTransaccionScreenBody extends StatelessWidget {

  final ProductsService? productsService;
  final Product? selectedProduct;
  final String bussinesToken;
   
  const _ViewTransaccionScreenBody({Key? key,required this.productsService,required this.selectedProduct,required this.bussinesToken}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    final selectedTransaccionProvider=Provider.of<SelectedTransaccion>(context);
    final selectedTransaccion=selectedTransaccionProvider.selectedTransaccion;
    final transaccionsService=Provider.of<TransaccionsService>(context);

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text("Vista de ")
        ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 120),
        child: Column(
          children: [
            Container(
              padding:EdgeInsets.symmetric(vertical:20),
              decoration:_buildBoxDecoration() ,
              width:double.infinity,
              height:size.height*0.3,
              child: Row(
                children: [
                  Container(
                    width: size.width*0.5,
                    child: Column(
                      children: [

                        Text("Concepto:",style: Theme.of(context).textTheme.headline6,),

                        SizedBox(height: 5,),

                        Container(
                          decoration: _buildBoxDecoration2(),
                          child: Text("${selectedTransaccion!.concept}"),
                        ),

                         SizedBox(height: 40,),

                        Text("Cantidad:",style: Theme.of(context).textTheme.headline6,),

                        SizedBox(height: 5,),

                        Container(
                          decoration: _buildBoxDecoration2(),
                          child: Text("${selectedTransaccion.amount}"),
                        ),




                      ],
                    ),
                  ),

                  VerticalDivider(color: Colors.black,),

                Container(
                  width:size.width*0.4,
                  child: Column(
                    children: [

                      
                        Text("Método de Pago:",style: Theme.of(context).textTheme.headline6,),

                        SizedBox(height: 5,),

                        Container(
                          decoration: _buildBoxDecoration2(),
                          child: Text("${selectedTransaccion.paymentMethod}"),
                        ),

                        SizedBox(height: 18,),

                        
                        Text("Valor:",style: Theme.of(context).textTheme.headline6,),

                        SizedBox(height: 5,),

                        Container(
                          decoration: _buildBoxDecoration2(),
                          child: Text("${selectedTransaccion.value}"),
                        )



                    ],
                  ),

                )

              ],),
            ),

            SizedBox(height:10),

           Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                     disabledColor: Colors.grey,
                     onPressed:
                       transaccionsService.isDeleting==true
                      ?null
                      :() {

                        displayDialogAndroid(context,transaccionsService,selectedTransaccion);

                        
                      },
                     child:Container(
                       padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
                       decoration: _boxDecorationDelete(color:Colors.red),
                       child: transaccionsService.isDeleting ==true
                       ?
                       Text('Eliminando',style: TextStyle(color: Colors.white),)
                       :
                       Text('Eliminar',style: TextStyle(color: Colors.white),)
                     ) 
                   ),


                      MaterialButton(
                     onPressed:() {

                        Navigator.pushReplacementNamed(context,'transaccion', arguments: [bussinesToken,productsService,null] );

                        
                      },
                     child:Container(
                       padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
                       decoration: _boxDecorationDelete(color:Colors.indigo),
                       child: Text('Editar',style: TextStyle(color: Colors.white),)
                     ) 
                   ),
              ],
            ),

          ],
        ),
      )
    );
  }

 BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
       color: Colors.white,
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

   BoxDecoration _buildBoxDecoration2() {
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

  void displayDialogAndroid(BuildContext context,TransaccionsService transaccionService,Transaccion selectedTransaccion){
     
       

           showDialog(

        barrierDismissible: false,
        context: context,
        builder: (context) {
           
          return AlertDialog(
            
     
            elevation: 5,
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text('Advertencia'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('¿Està seguro que desea eliminar la transacción?',),
                SizedBox(height: 10,),
              ],
            ),

            actions: [TextButton(
              onPressed: (){
                  Navigator.pushReplacementNamed(context,'home');//Cierra la imagen al presionar el texbutton de cancelar
              },
             child: const Text('Cancelar',style: TextStyle(color:Colors.blue),)
             ),
             TextButton(
              onPressed: ()async{

                

                
                  
                  await  transaccionService.deleteTransaccion(selectedTransaccion);
                  
                  

                  Navigator.pushReplacementNamed(context,'home');
                  
                  
              },
             child: const Text('Aceptar',style: TextStyle(color:Colors.red))
             )
             
             
             
             
             ],

          );
        },
        
      
       );

     
  }


  
  BoxDecoration _boxDecorationDelete({required Color color}) {
    return BoxDecoration(
      color:color,
      borderRadius: BorderRadius.all(Radius.circular(25)),
      boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5

      )
    ]
   );
  }



}