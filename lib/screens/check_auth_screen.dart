import 'package:flutter/material.dart';
import 'package:productos_app/screens/home_screen.dart';
import 'package:productos_app/screens/loading_screen.dart';
import 'package:productos_app/screens/login_screen.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
   
  const CheckAuthScreen({Key? key}) : super(key: key);


  
  @override
  Widget build(BuildContext context) {
      final authService=Provider.of<AuthService>(context,listen:false);


    return  Scaffold(
      body: Center(
         child: FutureBuilder(
           future: authService.readToken(),
           builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
             print('Checking: `$snapshot`');

             if(!snapshot.hasData){
                return LoadingScreen();
             }

             if(snapshot.data == ''){
                Future.microtask((){//Redirreciona a la página una vez el widget ha sido creado
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_,__,___)=>LoginScreen(),
                  transitionDuration: Duration(seconds: 0)
                  ));

             });
             }else{
                Future.microtask((){//Redirreciona a la página una vez el widget ha sido creado
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_,__,___)=>HomeScreen(),
                  transitionDuration: Duration(seconds: 0)
                  ));

             });
             }

           

             return Container();
             
           },
         ),
      ),
    );
  }
}