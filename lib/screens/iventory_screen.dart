import 'package:flutter/material.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/search/product_search_delegate.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';

import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';



class IventoryScreen extends StatelessWidget   {
   
  final AuthService authService;
  final BussinesService bussinesService;
  final Bussines selectedBussines;
  final String bussinesToken;

  const IventoryScreen({Key? key,required this.authService,required this.bussinesService,required this.selectedBussines, required this.bussinesToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
   

    final productsService = Provider.of<ProductsService>(context);


       
      
   
     

    

    final size=MediaQuery.of(context).size;


     List<double> multiplication=[];

                    double accumulator=0;

                    for (var i = 0; i < productsService.products.length; i++) {
                        multiplication.add(productsService.products[i].amount.toDouble()*productsService.products[i].buyPrice!);
                    }

                    
                    for (int i = 0; i < multiplication.length; i++) {
                        
                        accumulator=accumulator+multiplication[i];
                    }


                    
                  
                        
                
                    

                   

                   

  
    
    if( productsService.isLoading ) return LoadingScreen();
 
     return   Column(
       children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal:27,vertical: 15),
          child: Container(
            padding:EdgeInsets.symmetric(horizontal: 10),
            decoration: _buildBoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              child: MaterialButton(
                onPressed: () async {
                  
                 
                  showSearch(context: context, delegate: ProductSearchDelegate(productsSearch: await productsService.searchProducts(), bussinesService: bussinesService, bussinesToken: bussinesToken, selectedBussines: selectedBussines));

                },
                child: Row(
                  children: [
                    Icon(Icons.search,color: Colors.indigo,),
                    Text("Buscar en el inventario",style: Theme.of(context).textTheme.caption,),
                  ],
                ),
                ),
            ),
          ),
        ),



          Container(
            height:size.height*0.10,
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
                        
                        Text('${multiplication.length.toString()}')
                        
                          
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
                          
                        Text('${accumulator.toString()}')
                        
                          
                        ],
                    ),
                  ),
                )
              ],
            ),
          ),
         
             Padding(
               padding: const EdgeInsets.symmetric(horizontal:15.0),
               child: AppBackground(
                 widget: ListView.builder(
                  itemCount: productsService.products.length,
                  itemBuilder: ( BuildContext context, int index ) {
                    
                    

                      return GestureDetector(
                        onTap: () {

                         
                      
                          Provider.of<SelectedProduct>(context,listen: false).selectedProduct = productsService.products[index].copy();
                          Navigator.pushNamed(context, 'viewproduct',arguments: [bussinesService,bussinesToken,selectedBussines]);
                      },
                        child: ProductCard(product: productsService.products[index]),
                   );
                    
                  } 
                ),
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

          
             Navigator.pushNamed(context, 'product',arguments: [bussinesService,bussinesToken,selectedBussines]);
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
