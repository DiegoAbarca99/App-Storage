
import 'package:flutter/material.dart';
import 'package:productos_app/models/bussines.dart';
import 'package:productos_app/services/services.dart';



class BussinesScreen extends StatelessWidget {
  final BussinesService bussinesService;
  final Bussines selectedBussines;
   
  const BussinesScreen({Key? key,required this.selectedBussines,required this.bussinesService}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final size=MediaQuery.of(context).size;
    

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0),
      child: SingleChildScrollView(
        child: Column(
          children:[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: AlignmentDirectional.center,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenido',
                    style:TextStyle(fontSize: 20)),
                    Text(
                      "${selectedBussines.ownerName}",
                      style:TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 20))
                  ],
              ),
              width: double.infinity,
              height: size.height*0.15,
             
               
             ),

             SizedBox(height: 10,),
      
      
              Text("Datos de la empresa:",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
      
              SizedBox(height: 20,),
      
              Container(
                
                width: double.infinity,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
      
                        Text("Nombre de la empresa:",style: TextStyle(fontSize: 15),),
                        
                        SizedBox(height: 5,),
      
                        Container(
                          alignment: AlignmentDirectional.center,
                          width: size.width*0.45,
                          decoration: _buildBoxDecoration(),
                          child:Text("${selectedBussines.bussinesName}",style: TextStyle(fontSize: 15),)),
      
                        SizedBox(height: 10,),
      
                        Text("Tipo de empresa:",style: TextStyle(fontSize: 15),),
                        
                        SizedBox(height: 5,),
      
                        Container(
                          alignment: AlignmentDirectional.center,
                          width: size.width*0.45,
                          decoration: _buildBoxDecoration(),
                          child:Text("${selectedBussines.kindBussines}",style: TextStyle(fontSize: 15),)),
      
                         SizedBox(height: 10,),
      
                        Text("Dirección:",style: TextStyle(fontSize: 15),),
                        
                        SizedBox(height: 5,),
      
                        Container(
                          alignment: AlignmentDirectional.center,
                          width: size.width*0.45,
                          decoration: _buildBoxDecoration(),
                          child:Text("${selectedBussines.direction}",style: TextStyle(fontSize: 15),)),
      
      
      
                      ],),

                      SizedBox(width: 10,),
      
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: FadeInImage(image: NetworkImage("https://thumbs.dreamstime.com/b/cityscape-design-corporaci%C3%B3n-de-edificios-logo-para-la-empresa-inmobiliaria-158041738.jpg"),
                          placeholder: AssetImage('assets/jar-loading.gif',),
                          fit: BoxFit.cover,
                          ),
                        ),
                        
                        height:size.height*0.3,
                        width: size.width*0.4,
                      )
                  ],
                ),),

                SizedBox(height: 20,),

                Text("Descripcion",style: TextStyle(fontSize: 15),),

                SizedBox(height:5),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: AlignmentDirectional.center,
                  width:double.infinity,
                  height: size.height*0.10,
                  decoration: _buildBoxDecoration(),
                  child:Text(
                    selectedBussines.description==null
                    ?"No hay descripción"
                    :"${selectedBussines.description}",
                    style: TextStyle(fontSize: 15)
                  )
                ),
             
             SizedBox(height: 25,),

           
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
              color: Colors.indigo,
              child: Container(
                padding: EdgeInsets.symmetric( horizontal: 60, vertical: 15),
                child: Text( 'Editar empresa ',
                  style: TextStyle( color: Colors.white ),
                )),
                
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'viewbussines',arguments:[selectedBussines,bussinesService]);
              }),
             
             SizedBox(height: 20,)
            
            ]
          ),
      ),
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