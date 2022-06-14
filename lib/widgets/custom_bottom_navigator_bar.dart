import 'package:flutter/material.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigatorBar extends StatelessWidget {
  const CustomBottomNavigatorBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ui=Provider.of<UiProvider>(context);

    final currentIndex=ui.selectMenuOpt;
    return BottomNavigationBar(

      onTap:(int i)=>ui.selectMenuOpt=i,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      backgroundColor: Colors.indigo,
      unselectedItemColor: Colors.indigo.shade900,
      currentIndex:currentIndex, //Denota el item seleccionado.
      items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home),
      label: 'Inicio' 
      ),

      BottomNavigationBarItem(icon: Icon(Icons.view_in_ar_outlined),
      label:'Inventario'
      ),

       BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined),
      label:'Balance'
      ),

      BottomNavigationBarItem(icon: Icon(Icons.person),
      label:'Clientes'
      ),

      BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined),
      label:'Proveedores'
      ),


     
      

    ]);
  }
}