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
    final selectedBussines=Provider.of<SelectedBussinesProvider>(context).selectedBussines;

    final size=MediaQuery.of(context).size;


     List<double> multiplication=[];

                    double accumulator=0;

                    for (var i = 0; i < productsService.products.length; i++) {
                        multiplication.add(productsService.products[i].amount.toDouble()*productsService.products[i].buyPrice!);
                    }

                    
                    for (int i = 0; i < multiplication.length; i++) {
                        
                        accumulator=accumulator+multiplication[i];
                    }

                    selectedBussines!.totalCost=accumulator;

                    print('costo total: ${selectedBussines.totalCost}, acumulador: $accumulator, producto: $multiplication'  , );

  
    
    if( productsService.isLoading ) return LoadingScreen();
 
     return   Column(
       children: [

          Container(
            height:size.height*0.23,
            width:double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FittedBox(
                  fit:BoxFit.contain,
                  child: Container(
                    width: 150,
                    decoration:_buildBoxDecoration(),
                    child: Column(
                      children: [
                        
                        Text('Total de referencias'),
                        
                        Text('${selectedBussines!.referenceNumber.toString()}')
                        
                          
                        ],
                    ),
                  ),
                ),
          
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    width: 120,
                    decoration: _buildBoxDecoration(),
                    child: Column(
                      children: [
                          
                        Text('Costo total'),
                          
                        Text('${selectedBussines.totalCost.toString()}')
                        
                          
                        ],
                    ),
                  ),
                )
              ],
            ),
          ),
         
             AppBackground(
               widget: ListView.builder(
                itemCount: productsService.products.length,
                itemBuilder: ( BuildContext context, int index ) {

                    return GestureDetector(
                      onTap: () {
                        Provider.of<SelectedProduct>(context,listen: false).selectedProduct = productsService.products[index].copy();
                        Navigator.pushNamed(context, 'viewproduct');
                    },
                      child: ProductCard(product: productsService.products[index]),
                 );
                  
                } 
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

          
             Navigator.pushNamed(context, 'product');
          }
          
          ), 

           SizedBox(height:15),
       ],
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
}
