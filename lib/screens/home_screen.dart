import 'package:flutter/material.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/screens/alert_screen.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';

import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';




class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService=Provider.of<AuthService>(context);
    print('User token desde el homescreen: `${authService.userToken}`');

    if(authService.firsTime){
         
        print("Ejecutando formulario .........................");
        return AlertScreen();
     
    }else{
      return ChangeNotifierProvider(
        create: (context)=>ProductsService(userToken:authService.userToken ),
        child: HomeScreenBody(authService: authService,),
      );

    }
    


  
  }
}


class HomeScreenBody extends StatelessWidget   {
   
  final AuthService authService;

  const HomeScreenBody({Key? key,required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
   

    final productsService = Provider.of<ProductsService>(context);

   

    

    
    
    if( productsService.isLoading ) return LoadingScreen();


    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        leading: IconButton(
          icon: Icon(Icons.login_outlined),
           onPressed: () { 
             
             authService.logout();
             Navigator.pushReplacementNamed(context, 'login');

            },
        ),
      ),
      body: ListView.builder(
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
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        onPressed: () async {

          Provider.of<SelectedProduct>(context,listen: false).selectedProduct= new Product(
            name: '', 
            sellPrice: 0, 
            amount: 0, 
            buyPrice: 0, 
            description: '',
          
          );

          Provider.of<SelectedProduct>(context,listen: false).isSelected=false;
          
          Navigator.pushNamed(context, 'product');
        },
      ),

      bottomNavigationBar:CustomBottomNavigatorBar()
   );
  }
}