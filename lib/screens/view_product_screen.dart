import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/services/services.dart';



class ViewProductScreen extends StatelessWidget {
  const ViewProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final list=ModalRoute.of(context)!.settings.arguments as List;
    final bussinesService=list[0];
    final bussinesToken=list[1];
    final selectedBussines=list[2];
    final userToken=Provider.of<AuthService>(context).userToken;

    print("Busineess token desde view product !!!!!! $bussinesToken");

    return MultiProvider(
      providers: [
         ChangeNotifierProvider(
           create: ( _ ) => ProductsService(userToken:userToken,bussinesToken: bussinesToken ),
          ),

      ],
      child: ViewProductScreenBody(bussinesService: bussinesService, bussinesToken: bussinesToken, selectedBussines: selectedBussines,),
      );
    
  }
}

class ViewProductScreenBody extends StatelessWidget {
  final String bussinesToken;
  final Bussines selectedBussines;
  final BussinesService bussinesService;

  const ViewProductScreenBody({Key? key,required this.bussinesService,required this.selectedBussines,required this.bussinesToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {

   final selectedProduct=Provider.of<SelectedProduct>(context);
   final productService=Provider.of<ProductsService>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text('Vista de ${selectedProduct.selectedProduct!.name}'),),
      body: SingleChildScrollView(
        child:Column(
          children: [
            Row(
              children: [

                ProductImage( url: selectedProduct.selectedProduct!.picture ),
    
                 Container(
                    width: 140,
                    height:200 ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
            
            
                        SizedBox(height: 20,),
                    
                        Text('Código',style: TextStyle(fontSize:20 ,fontWeight: FontWeight.bold),),
                    
                        SizedBox(height: 5,),

                        FittedBox(
                          fit: BoxFit.contain,
                          child: Container(
                            width:170,
                            height: 40,
                            decoration: _buildBoxDecoration(),
                            child: Text(selectedProduct.selectedProduct!.qrCode??''),
                          ),
                        ),
                    

                        SizedBox(height: 10,),
                    
                         Text('Cantidad',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    
                        SizedBox(height: 5,),

                        Container(
                          alignment: AlignmentDirectional.center,
                          width:120,
                          height: 40,
                          decoration: _buildBoxDecoration(),
                          child: Text(selectedProduct.selectedProduct!.amount.toString()),
                        ),
            
                        
            
                    
                    
                    
                        ],
                    ),
                  ),
              ],
            ),


          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: _buildBoxDecoration(),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Center(
                child:Text(
                  '${selectedProduct.selectedProduct!.name}',
                  style: Theme.of(context).textTheme.headline6,
                ) ,),

              SizedBox(height: 15,),

              

              Text('Precio de venta',style: TextStyle(fontWeight: FontWeight.bold),),
              Text('\$ ${selectedProduct.selectedProduct!.sellPrice.toString()}'),

              SizedBox(height: 15,),

              Text('Precio de compra',style: TextStyle(fontWeight: FontWeight.bold),),
              Text('\$ ${selectedProduct.selectedProduct!.buyPrice.toString()}'),

              SizedBox(height: 15,),

              Text('Descripción',style: TextStyle(fontWeight: FontWeight.bold),),
              Text('${selectedProduct.selectedProduct!.description}'),
                ],
              ),
            ),
          ),
           

            SizedBox(height: 15,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                       disabledColor: Colors.grey,
                       onPressed:
                         productService.isDeleting==true
                        ?null
                        :() {

                          displayDialogAndroid(context,productService,selectedProduct.selectedProduct,bussinesService,selectedBussines);

                          
                        },
                       child:Container(
                         padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
                         decoration: _boxDecorationDelete(color:Colors.red),
                         child: productService.isDeleting==true
                         ?
                         Text('Eliminando',style: TextStyle(color: Colors.white),)
                         :
                         Text('Eliminar',style: TextStyle(color: Colors.white),)
                       ) 
                     ),


                        MaterialButton(
                       onPressed:() {

                          Navigator.pushReplacementNamed(context,'product',arguments: [bussinesService,bussinesToken,selectedBussines] );

                          
                        },
                       child:Container(
                         padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
                         decoration: _boxDecorationDelete(color:Colors.indigo),
                         child: Text('Editar',style: TextStyle(color: Colors.white),)
                       ) 
                     ),
                ],
              ),
          ],
        ) ,
      ),
    );

    

   
    
  }

  void displayDialogAndroid(BuildContext context,ProductsService productService,Product? selectedProduct,BussinesService bussinesService,Bussines selectedBussines){
     
       

           showDialog(

        barrierDismissible: false,
        context: context,
        builder: (context) {
           
          return AlertDialog(
            
     
            elevation: 5,
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text('Advertencia'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('¿Esta seguro que desea eliminar el producto?',),
                SizedBox(height: 10,),
              ],
            ),

            actions: [TextButton(
              onPressed: (){
                  Navigator.pushReplacementNamed(context,'home');//Cierra la imagen al presionar el texbutton de cancelar
              },
             child: const Text('Cancelar',style: TextStyle(color:Colors.blue),)
             ),
             TextButton(
              onPressed: ()async{

                

                  
                  final referenceNumber= Provider.of<ReferenceNumberProvider>(context,listen:false);
                  

                  referenceNumber.referenceNum=referenceNumber.referenceNum-1;
                  
                  await  productService.deleteProduct(selectedProduct!);
                  
                  

                  Navigator.pushReplacementNamed(context,'home');
                  
                  
              },
             child: const Text('Aceptar',style: TextStyle(color:Colors.red))
             )
             
             
             
             
             ],

          );
        },
        
      
       );

     
  }


  
  BoxDecoration _boxDecorationDelete({required Color color}) {
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
       color: Colors.white,
       borderRadius: BorderRadius.circular(25),
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




