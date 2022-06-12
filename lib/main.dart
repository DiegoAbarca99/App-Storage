import 'package:flutter/material.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/providers/selected_bussines_provider.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';

 
void main() =>runApp(AppState());

class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(create: ( _ ) => UiProvider() ),
        ChangeNotifierProvider(create: ( _ ) => SelectedProduct() ),
        ChangeNotifierProvider(create: ( _ ) => SelectedBussinesProvider() ),
        ChangeNotifierProvider(create: ( _ ) => AuthService() ), 
        ChangeNotifierProvider(create: ( _ ) => UserBussinesProvider()) , 
        ChangeNotifierProvider(create: ( _ ) => ReferenceNumberProvider()) ,
      ],
      child: MyApp(),
    );
  }
}



 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App-Storage',
      initialRoute: 'register',
      routes: {

        'home'    : ( _ ) => HomeScreen(),


        'product' : ( _ ) => ProductScreen(),
        'viewproduct':( _ ) => ViewProductScreen(),
         

        'login'   : ( _ ) => LoginScreen(),
        'register'   : ( _ ) => RegisterScreen(),

        
      },
      scaffoldMessengerKey:NotificationService.messengerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0
        )
      ),
    );
  }
}