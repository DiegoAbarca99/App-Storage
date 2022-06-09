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

      return Scaffold(
        appBar: AppBar(
          title: Text('Bienvenido'),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.login_outlined),
              onPressed: () { 
                 authService.logout();
                 Navigator.pushReplacementNamed(context, 'login');

              },
           ),
        ),
        body: _HomeScreenBody(authService: authService),
        bottomNavigationBar:CustomBottomNavigatorBar()
      );
      

    

    }
    


  
  }
}


class _HomeScreenBody extends StatelessWidget   {
   
  final AuthService authService;

  const _HomeScreenBody({Key? key,required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {

     final currentIndex=Provider.of<UiProvider>(context).selectMenuOpt;
    
    switch (currentIndex) {
      case 0 :
        return ChangeNotifierProvider(
          create: (_)=>BussinesService(userToken: authService.userToken),
          child: BussinesScreen(),
          );

      case 1:
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_)=>BussinesService(userToken:authService.userToken),
            ),
            ChangeNotifierProvider(
              create: (_)=>ProductsService(userToken:authService.userToken ),
            ),   
          ],
          child:IventoryScreen(authService: authService) ,
        );   
      default:
        return const BussinesScreen();
    }

 

     
   
  }
}