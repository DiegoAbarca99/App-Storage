import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';

import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productsService = Provider.of<ProductsService>(context);
    final userService=Provider.of<UserService>(context);
    final authService=Provider.of<AuthService>(context);
    final String? owner=ModalRoute.of(context)!.settings.arguments as String?;
    
    print(owner);

    if(userService.firsTime){
      print("Ejecutando formulario .........................");
      userService.firsTime=false;
       Future.microtask((){//Redirreciona a la página una vez el widget ha sido creado
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_,__,___)=>HomeScreen(),
                  transitionDuration: Duration(seconds: 0)
                  ));
       
              });
    }
    

    
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

            productsService.selectedProduct = productsService.products[index].copy();
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

          productsService.selectedProduct = new Product(
            name: '', 
            sellPrice: 0, 
            amount: 0, 
            buyPrice: 0, 
            emailOwner: owner,
            description: '',
            


            

          );
          Navigator.pushNamed(context, 'product');
        },
      ),
   );
  }
}