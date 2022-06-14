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
          title: Text('App-Storage'),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.login_outlined),
              onPressed: () { 
                 authService.logout();
                 Navigator.pushReplacementNamed(context, 'login');

              },
           ),
        ),
        body: ChangeNotifierProvider(
          create: (_)=>BussinesService(userToken:authService.userToken),
          child: _HomeScreenBody(authService: authService)),
        bottomNavigationBar:CustomBottomNavigatorBar()
      );
      

    

    }
    


  
  }
}


class _HomeScreenBody extends StatelessWidget   {
   
  final AuthService authService;

  const _HomeScreenBody({Key? key,required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context)  {
    
      Bussines selectedBussines;
      String? selectedUserBussines;


      final bussinesService= Provider.of<BussinesService>(context,listen: true);



     if(bussinesService.isLoading==false){
         print("Bussines desde el homescreen:${bussinesService.bussineses}");
         
            selectedBussines=bussinesService.bussineses[0];    
            selectedUserBussines=bussinesService.bussineses[0].id;
         

          final currentIndex=Provider.of<UiProvider>(context).selectMenuOpt;
          final bussinesToken= selectedUserBussines;
           print("Business token desde el homescreen: $bussinesToken ");

    
    switch (currentIndex) {
      case 0 :
        return BussinesScreen(selectedBussines: selectedBussines,bussinesService: bussinesService,);

      case 1:
        return  ChangeNotifierProvider(
              create: (_)=>ProductsService(userToken:authService.userToken,bussinesToken: bussinesToken ),
              child:IventoryScreen(authService: authService,bussinesService:bussinesService, selectedBussines:selectedBussines, bussinesToken: bussinesToken!, ) ,
            ); 
      case 2:
        return MultiProvider(
          providers:[

            ChangeNotifierProvider(
            create: (_)=>ProductsService(userToken:authService.userToken,bussinesToken: bussinesToken ),
            ),

             ChangeNotifierProvider(
            create: (_)=>TransaccionsService(bussinesToken: bussinesToken,userToken: authService.userToken),
            ),

            ],
            child: BalanceScreen(bussinesToken: bussinesToken!,selectedBussines: selectedBussines, bussinesService: bussinesService,)
          );
          
        

          
          
           
      default:
        return  CircularProgressIndicator();
    }




        
     }
  
       
    
        

  return Container();
    
   

 

     
   
  }
}