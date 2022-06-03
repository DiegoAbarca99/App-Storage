
import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:productos_app/services/products_service.dart';
import 'package:provider/provider.dart';

class WarningDeleteProductScreen extends StatelessWidget {
  const WarningDeleteProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userToken=Provider.of<AuthService>(context).userToken;
    return ChangeNotifierProvider(
      create:(_)=> ProductsService(userToken: userToken),
      child:WarningBody()
      );
  }
}

class WarningBody extends StatelessWidget {
   
  const WarningBody({Key? key}) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    final Product? selectedProduct=ModalRoute.of(context)!.settings.arguments as Product?;
    final productService=Provider.of<ProductsService>(context);

    return  Scaffold(
      body: displayDialogAndroid(context,productService,selectedProduct),
    );
}
            
           

      
  


   Widget displayDialogAndroid(BuildContext context,ProductsService productService,Product? selectedProduct){
     
        WidgetsBinding.instance!.addPostFrameCallback((_){


           showDialog(

        barrierDismissible: false,
        context: context,
        builder: (context) {
           
          return AlertDialog(
            
     
            elevation: 5,
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text('Advertencia',style: TextStyle(color: Colors.red)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('¿Esta seguro que desea eliminar el producto?',style: TextStyle(color: Colors.red),),
                SizedBox(height: 10,),
              ],
            ),

            actions: [TextButton(
              onPressed: (){
                  Navigator.pushReplacementNamed(context,'product');//Cierra la imagen al presionar el texbutton de cancelar
              },
             child: const Text('Cancelar',style: TextStyle(color:Colors.red),)
             ),
             TextButton(
              onPressed: ()async{
                  Navigator.pushReplacementNamed(context,'home');
                  await  productService.deleteProduct(selectedProduct!);
                  
              },
             child: const Text('Aceptar')
             )
             
             
             
             
             ],

          );
        },
        
      
       );



    });

    return Container(
    );
   

     
  }
}