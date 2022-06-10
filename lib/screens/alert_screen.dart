
import 'package:flutter/material.dart';
import 'package:productos_app/models/bussines.dart';
import 'package:productos_app/providers/providers.dart';

import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:provider/provider.dart';


class AlertScreen extends StatelessWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final bussines=Bussines(
      ownerName: '',
      bussinesName: '',
      kindBussines: '',
      description: '',
      direction: '',
      totalExpenses:null,
      totalSales:null, 
      utility: null,
      totalCost: 0,
      referenceNumber: 0
      );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_)=>BussinesService(userToken: authService.userToken),),
        ChangeNotifierProvider(create:(_)=>BussinesFormProvider(bussines), )
        ],
      child: _AlertScreenBody(),
    );
  }
}



class _AlertScreenBody extends StatelessWidget {
   
  const _AlertScreenBody({Key? key}) : super(key: key);
  

    static displayDialog(BuildContext context){
      final bussinesService=Provider.of<BussinesService>(context,listen:false);
      final bussinesForm=Provider.of<BussinesFormProvider>(context,listen: false);

      showDialog(

        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: AlertDialog(
              insetPadding: EdgeInsets.all(10),
              elevation: 5,
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: const Text('Datos de la empresa'),
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal:10.0),
                child: SingleChildScrollView(
                  child: _AlertForm(bussinesForm: bussinesForm,)
                  ),
              ),

              actions: [TextButton(
                onPressed: (){
                    Navigator.pop(context);//Cierra la imagen al presionar el texbutton de cancelar
                },
               child: Text('Cancelar',style: TextStyle(color:Colors.red),)
               ),


               TextButton(
                onPressed: bussinesForm.isLoading?null: () {
                   final authService= Provider.of<AuthService>(context,listen:false);

                    FocusScope.of(context).unfocus();

                    if(!bussinesForm.isValidBussinesForm()) return;

                    bussinesForm.isLoading=true;

                      bussinesService.saveOrCreateBussines(bussinesForm.bussines!);
                      Provider.of<SelectedBussinesProvider>(context,listen:false).selectedBussines=bussinesForm.bussines!;


                    

                   

                    bussinesForm.isLoading=false;

                    authService.firsTime=false;

                    Navigator.pushReplacementNamed(context,'home');//Cierra la imagen al presionar el texbutton de cancelar
                },
               child:  Text(
                      bussinesForm.isLoading 
                      ? 'Espere'
                      : 'Aceptar',
                 )
               )
               
               
               
               
               ],

            ),
          );
        },
        
      
       );
       
  }

  
  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        child: PageView(
          physics:const  BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: const [

            _Page1(),
            _Page2()
           
           ],
         ),
          
            
         
      ),

    );

      
  }





}


class _Page1 extends StatelessWidget {
  const _Page1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
         child: Stack(
           children:  [
             _Background(),
            _MainContent(),
        
           ],
         ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle =  TextStyle(fontSize:20,fontWeight: FontWeight.bold,color: Colors.white);
    return SafeArea(//Widget que ajusta el contenido que lo contiene a las dimensiones de la pantalla del dispositivo móvil en uso
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Expanded(child: Container()),
        Text('Bienvenido a la App°',style: textStyle,),
        SizedBox(height:20),
        Text('Dezlice la pantalla para comenzar',style:textStyle),
        Expanded(child: Container()), // El expanded se amplia  en su totalidad en toda la zona de la pantalla que no es ocupada por otros widgets
        const Icon(Icons.keyboard_arrow_down,size: 100,color: Colors.white,),
      ],),
    );
  }
}

class _Background extends StatelessWidget { 

  const _Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(child: _Bubble(), top: 20, left: 30 ),
          Positioned(child: _Bubble(), top: -40, left: -30 ),
          Positioned(child: _Bubble(), top: 20, right: -20 ),
          Positioned(child: _Bubble(), top: 50, right: 30 ),
          Positioned(child: _Bubble(), bottom: -50, left: 10 ),
          Positioned(child: _Bubble(), bottom: 120, right: 20 ),
          Positioned(child: _Bubble(), bottom: 90, right: -50 ),
          Positioned(child: _Bubble(), bottom: 30, left: 10 ),
        ],
      ),
    );
  }
}

BoxDecoration _purpleBackground() => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1)
      ]
    )
  );




class _Page2 extends StatelessWidget {
  const _Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
      children: [

         _Background(),

        Center(
          child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary:Colors.indigo.shade300,
                      elevation: 10,
                      shape: StadiumBorder(),
                      
                    ),
                    child: Text('Comenzar',style: TextStyle(fontSize: 30),),
                     
                onPressed:(){
                  _AlertScreenBody.displayDialog(context);
                },  
          ),
        ),

        

      ],
      )
  );
  }
}

class _PurpleBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(child: _Bubble(), top: 90, left: 30 ),
          Positioned(child: _Bubble(), top: -40, left: -30 ),
          Positioned(child: _Bubble(), top: -50, right: -20 ),
          Positioned(child: _Bubble(), bottom: -50, left: 10 ),
          Positioned(child: _Bubble(), bottom: 120, right: 20 ),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1)
      ]
    )
  );
}

class _Bubble extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );
  }
}


class _AlertForm extends StatelessWidget {

  final BussinesFormProvider bussinesForm;

  const _AlertForm({
    Key? key, required this.bussinesForm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  

    return Form(
      key: bussinesForm.bussinesformKey,
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children:  [

          Text('Nombre del negocio'),

          SizedBox(height: 5,),

          TextFormField(

            keyboardType: TextInputType.name,
             onChanged: ( value ) => bussinesForm.bussines!.bussinesName = value,
             validator: ( value ) {
             if ( value == null || value.length < 1 )
             return 'Este campo es obligatorio'; 
             },
               decoration: InputDecorations.authInputDecoration(
               hintText: 'Nombre del negocio', 
               labelText: 'Negocio:'
                ),
            ),


            SizedBox(height: 10,),


            Text('Tipo de negocio'),

            SizedBox(height: 5,),

             DropdownButtonFormField<String> (
             items: [
                DropdownMenuItem(
                  value:'Tienda de Abarrotes',
                  child:Row(
                    children:[
                      Icon(Icons.arrow_forward_ios_outlined),
                      Text('Tienda de Abarrotes'),
                      
                       ],)),
                DropdownMenuItem(value:'Tienda de Ropa',
                 child:Row(
                    children:[
                       Icon(Icons.arrow_forward_ios_outlined),
                       Text('Tienda de Ropa'),
                  
                       ],)
                ),
                DropdownMenuItem(value:'Ferreteria',
                 child:Row(
                    children:[
                      Icon(Icons.arrow_forward_ios_outlined),
                      Text('Ferreteria'),
                      
                       ],)
                ),
                DropdownMenuItem(value:'Carniceria',
                 child:Row(
                    children:[
                      Icon(Icons.arrow_forward_ios_outlined),
                      Text('Carniceria'),
                    
                     
                       ],)
                ),
                DropdownMenuItem(value:'Otro',
                 child:Row(
                    children:[
                      Icon(Icons.arrow_forward_ios_outlined),
                      Text('Otro'),
                    
                       ],)
                ),
            ],
            onChanged: (value){
              bussinesForm.bussines!.kindBussines=value;
            

            }
              ),

              SizedBox(height: 10,),
              
              Text('Dirección del negocio'),//

              SizedBox(height: 5,),

            TextFormField(
            keyboardType: TextInputType.name,
             onChanged: ( value ) => bussinesForm.bussines!.direction = value,
             validator: ( value ) {
             if ( value == null || value.length < 1 )
             return 'Este campo es obligatorio'; 
             },
               decoration: InputDecorations.authInputDecoration(
               hintText: '(Calle, número y colonia)', 
               labelText: 'Direcciòn:'
                ),
            ),

              SizedBox(height: 10,),
              
              Text('Nombre del propietario'),//

              SizedBox(height: 5,),
              
            TextFormField(
            keyboardType: TextInputType.name,
             onChanged: ( value ) => bussinesForm.bussines!.ownerName = value,
             validator: ( value ) {
             if ( value == null || value.length < 1 )
             return 'Este campo es obligatorio'; 
             },
               decoration: InputDecorations.authInputDecoration(
               hintText: 'Juan Perez ', 
               labelText: 'Propietario:'
                ),
            ),

            
              SizedBox(height: 10,),
              
            Text('Descripcion del negocio (opcional)'),//

            SizedBox(height: 5,),
              
            TextFormField(
            keyboardType: TextInputType.name,
             onChanged: ( value ) => bussinesForm.bussines!.description = value,
               decoration: InputDecorations.authInputDecoration(
               hintText: 'Mi negocio se enfoca a...', 
               labelText: 'Descripción:'
                ),
            ),


          
         
        ],
      ),
    );
  }
}