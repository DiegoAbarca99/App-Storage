import 'package:flutter/material.dart';
import 'package:productos_app/models/bussines.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:provider/provider.dart';


class ViewBussinesScreen extends StatelessWidget {
  const ViewBussinesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final list=ModalRoute.of(context)!.settings.arguments as List;

    final selectedBussines=list[0];
    final bussinesService=list[1];
    return ChangeNotifierProvider(
      create:(_)=>BussinesFormProvider(selectedBussines),
      child:_ViewBussinesScreenBody(bussinesService: bussinesService,)
    );
  }
}

class _ViewBussinesScreenBody extends StatelessWidget {

  final BussinesService bussinesService;
   
  const _ViewBussinesScreenBody({Key? key,required this.bussinesService}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    final bussinesForm = Provider.of<BussinesFormProvider>(context);
    final bussines = bussinesForm.bussines;

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Editar-Empresa"),
      ),
      body: SingleChildScrollView(
        child:Column(
          children: [
              Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: _buildBoxDecoration(),
      child: Form(
        key: bussinesForm.bussinesformKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
              
            SizedBox( height: 15 ),

             Text('Nombre del negocio'),

            SizedBox(height: 5,),
              
            TextFormField(
              initialValue: bussines!.bussinesName,
              onChanged: ( value ) => bussines.bussinesName = value,
              validator: ( value ) {
                if ( value == null || value.length < 1 )
                  return 'El nombre es obligatorio'; 
              },
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Nombre de la empresa', 
                labelText: 'Nombre:'
              ),
            ),
              
            SizedBox( height: 15 ),

            Text('Tipo de negocio'),

            SizedBox(height: 5,),

             DropdownButtonFormField<String> (
              value: bussines.kindBussines,
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

              
            
            
            SizedBox( height: 15 ),

            Text('Dirección del negocio'),//

              SizedBox(height: 5,),

            TextFormField(
            initialValue: bussines.direction,
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
              
              
              
            SizedBox( height: 15 ),
            Text('Nombre del propietario'),//

              SizedBox(height: 5,),
              
            TextFormField(
            initialValue: bussines.ownerName,
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
             
             SizedBox( height: 15 ),

             Text('Descripcion del negocio (opcional)'),//

            SizedBox(height: 5,),
              
            TextFormField(
            initialValue: bussines.description,
            keyboardType: TextInputType.name,
             onChanged: ( value ) => bussinesForm.bussines!.description = value,
               decoration: InputDecorations.authInputDecoration(
               hintText: 'Mi negocio se enfoca a...', 
               labelText: 'Descripción:'
                ),
            ),

            SizedBox(height: 15,),

             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 Container(
                   alignment: AlignmentDirectional.center,
                   padding:const EdgeInsets.symmetric(horizontal: 20),
                  child: TextButton(
                     child: Container(
                        alignment: AlignmentDirectional.center,
                         width:100,
                        padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
                        decoration: _boxDecorationButton(color: Colors.indigo),
                        child: Text(
                          bussinesService.isSaving==true
                          ?'Espere'
                          :'Guardar',style: TextStyle(color: Colors.white),),
                      ),
                  onPressed: bussinesService.isSaving==true
                  ? null
                  : () async {
            
                  if ( !bussinesForm.isValidBussinesForm() ) return
                                        

                    print("Hola mundo");
                  await bussinesService.updateBussines(bussinesForm.bussines!);
                  Navigator.pushReplacementNamed(context, 'home');
                 },
            ),
          ),


        Container(
                   alignment: AlignmentDirectional.center,
                   padding:const EdgeInsets.symmetric(horizontal: 20),
                  child: TextButton(
                     child: Container(
                        alignment: AlignmentDirectional.center,
                         width:100,
                        padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
                        decoration: _boxDecorationButton(color: Colors.red),
                        child: Text('Cancelar',style: TextStyle(color: Colors.white),),
                      ),
                  onPressed:() async {
            ;
                  Navigator.pushReplacementNamed(context, 'home');
                 },
            ),
          ),


      ],
  ),


  SizedBox(height: 20,)
              
              
          ],
        ),
      ),
    )

          ],
        ) ,)
    );
  }

  
  

  BoxDecoration _boxDecorationButton({required Color color}) {
    return BoxDecoration(
      color:color,
      borderRadius: BorderRadius.all(Radius.circular(25)),
      boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5

      )
    ]
   );
  }

 BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(25),
       color: Colors.white,
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