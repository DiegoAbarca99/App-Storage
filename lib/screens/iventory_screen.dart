import 'package:flutter/material.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';

import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';



class IventoryScreen extends StatelessWidget   {
   
  final AuthService authService;

  const IventoryScreen({Key? key,required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
   

    final productsService = Provider.of<ProductsService>(context);
    final size=MediaQuery.of(context).size;
  
    
    if( productsService.isLoading ) return LoadingScreen();
 
     return   Column(
       children: [

          Container(
            height:size.height*0.23,
            width:double.infinity,
            color:Colors.red
          ),
         
             AppBackground(
               widget: ListView.builder(
                itemCount: productsService.products.length,
                itemBuilder: ( BuildContext context, int index ) => GestureDetector(
                  onTap: () {
                       
                    Provider.of<SelectedProduct>(context,listen: false).selectedProduct = productsService.products[index].copy();
                    Provider.of<SelectedProduct>(context,listen: false).isSelected=true;
                    Navigator.pushNamed(context, 'product');
                  },
                  child: ProductCard(
                    product: productsService.products[index],
                  ),
                )
                         ),
             ),
          

         SizedBox(height:15),

          MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
              color: Colors.indigo,
              child: Container(
                padding: EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                child: Text( 'Agregar Producto',
                  style: TextStyle( color: Colors.white ),
                )
              ),
              onPressed:() async {

                Provider.of<SelectedProduct>(context,listen: false).selectedProduct= new Product(
                 name: '', 
                 sellPrice: 0, 
                 amount: 0, 
                 buyPrice: 0, 
                 description: '',
          
                );

              Provider.of<SelectedProduct>(context,listen: false).isSelected=false;
          
             Navigator.pushNamed(context, 'product');
          }
          
          ), 

           SizedBox(height:15),
       ],
     );
      

     

  }
}