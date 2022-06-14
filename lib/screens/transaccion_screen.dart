import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/providers/transaccion_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:provider/provider.dart';

class TransaccionScreen extends StatelessWidget {
  const TransaccionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final list=ModalRoute.of(context)!.settings.arguments as List;
    final bussinesToken=list[0];
    final ProductsService? productsService=list[1];
    final Product? selectedProduct =list[2];

    final authService = Provider.of<AuthService>(context);
    print("Busineess token desde el transaccion screen!!!!!! $bussinesToken");

    final selectedTransaccion=Provider.of<SelectedTransaccion>(context).selectedTransaccion;

    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ( _ ) => TransaccionsService(userToken:authService.userToken,bussinesToken: bussinesToken ),
          ),

        ChangeNotifierProvider(
          create: ( _ ) => TransaccionFormProvider(selectedTransaccion ),
          )
      ],
        child: _TransaccionScreenAsistant(productsService: productsService,selectedProduct: selectedProduct, bussinesToken: bussinesToken,),
      );
     
    
    
  }
}


class _TransaccionScreenAsistant extends StatelessWidget {

  final ProductsService? productsService;
  final Product? selectedProduct;
  final String bussinesToken;
   
  const _TransaccionScreenAsistant({Key? key, required this.productsService, this.selectedProduct,required this.bussinesToken}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final transaccionService=Provider.of<TransaccionsService>(context);
    final formKey=Provider.of<TransaccionFormProvider>(context);
    final transaccion=Provider.of<TransaccionFormProvider>(context).transaccion;

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Editar-Transacción"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

        Row(
          children:[
            Padding(
              padding: const EdgeInsets.only(top:15.0,bottom:15,left:80),
              child: Container(
                
                decoration: _buildBoxDecoration(),
                
                child:Row(
                  children: [

                    SizedBox(width:10),

                    Text("Escanear Producto"),


                    MaterialButton(
                      child:Icon(Icons.qr_code_scanner_outlined),
                      onPressed: ()async{


                       await productsService!.loadProducts();

                       final products=productsService!.products;

                       print("Productos cargados desde el Qr: $products");




                      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                      '#3D88EF', 
                                      'Cancelar', 
                                      false, 
                                      ScanMode.QR);
                      print(barcodeScanRes);
    
                      if(barcodeScanRes=='-1'){
                        return;
                      }

                          
                     final product=products.firstWhere((element) => element.qrCode==barcodeScanRes);
                   
                    // print("Producto escaneadoo y encontrado: ${product!.name??}");

                       Navigator.pushReplacementNamed (context, 'transaccion',arguments: [bussinesToken,productsService,product]);


                      
                      



                      },
                      
                      ),
                  ],
                )),
            )
          ]
         

        ),
            

        Padding(
          padding: const EdgeInsets.symmetric(horizontal:20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            decoration: _buildBoxDecoration(),
            child: Form(
            key: formKey.transaccionformKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
            children: [
                
              SizedBox( height: 15 ),

               Text('Concepto'),

              SizedBox(height: 5,),
                
              TextFormField(
                initialValue: selectedProduct==null
                                                  ?
                                                  transaccion!.concept
                                                  :
                                                  selectedProduct!.name,

                onChanged: ( value ) =>  transaccion!.concept = value,
                                                           
                validator: ( value ) {
                  if ( value == null || value.length < 1 )
                    return 'El nombre es obligatorio'; 
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Concepto', 
                  labelText: 'Concepto'
                ),
              ),
                
              SizedBox( height: 15 ),

              Text('Método de Pago'),

              SizedBox(height: 5,),

               DropdownButtonFormField<String> (
                value: transaccion!.paymentMethod,
               items: [
                  DropdownMenuItem(
                    value:'Efectivo',
                    child:Row(
                      children:[
                        Icon(Icons.money_outlined),
                        Text('Efectivo'),

                         ],)),
                  DropdownMenuItem(
                  value:'Tarjeta',
                   child:Row(
                      children:[
                         Icon(Icons.credit_card),
                         Text('Tarjeta'),
                    
                         ],)
                  ),
                  DropdownMenuItem(
                    value:'Transferencia',
                   child:Row(
                      children:[
                        Icon(Icons.transfer_within_a_station_outlined),
                        Text('Tranferencia Bancaria'),
                        
                         ],)
                  ),
                  DropdownMenuItem(
                    value:'Otro',
                   child:Row(
                      children:[
                        Icon(Icons.arrow_forward_ios_outlined),
                        Text('Otro'),
                      
                       
                         ],)
                  ),
                
              ],
              onChanged: (value){
                transaccion.paymentMethod=value;
              

              }
                ),

                
              
              
              SizedBox( height: 15 ),

              Text('Valor'),//

                SizedBox(height: 5,),

                

              TextFormField(
              initialValue:  selectedProduct==null
                                            ?
                                            transaccion.value.toString()
                                            :
                                            transaccion.type=='Gain'
                                                                    ?
                                                                    selectedProduct!.sellPrice.toString()
                                                                                              :
                                                                                              selectedProduct!.buyPrice.toString(),
               inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  onChanged: ( value ) {
                    if ( double.tryParse(value) == null ) {

                      transaccion.value = 0;
                    } else {
                      transaccion.value = double.parse(value);
                    }
                  },
                 decoration: InputDecorations.authInputDecoration(
                 hintText: 'Valor', 
                 labelText: 'Valor:'
                  ),
              ),


              SizedBox( height: 15 ),

              Text('Cantidad'),//

                SizedBox(height: 5,),

                

              TextFormField(
              initialValue: transaccion.amount.toString(),
                                           
                                                                                            
               inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  onChanged: ( value ) {
                    if ( double.tryParse(value) == null ) {

                      transaccion.amount = 0;
                    } else {
                      transaccion.amount = int.parse(value);
                    }
                  },
                 decoration: InputDecorations.authInputDecoration(
                 hintText: 'Cantidad', 
                 labelText: 'Cantidad:'
                  ),
              ),
                
                
                
              SizedBox( height: 15 ),
              Text('Tipo'),//

                SizedBox(height: 5,),

                   DropdownButtonFormField<String> (
                  value: transaccion.type,
                  items: [
                    DropdownMenuItem(
                      value:'Gain',
                      child:Row(
                        children:[
                          Icon(Icons.arrow_upward_outlined,color: Colors.green,),
                          Text('Venta',style: TextStyle(color: Colors.green),),
                         ],
                        )
                      ),
                      
            DropdownMenuItem(
                value:'loss',
                child:Row(
                  children:[
                    Icon(Icons.arrow_downward_outlined,color:Colors.red,),
                    Text('Gasto',style: TextStyle(color: Colors.red),),
                    
                    ],
                  )
                ),
            ],
              onChanged: (value){
                transaccion.type=value!;
              
              }
            ),

             
                 
               SizedBox( height: 15 ),

          
              MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
              color: Colors.indigo,
              child: Container(
                padding: EdgeInsets.symmetric( horizontal: 40, vertical: 10),
                child: Text(
                          transaccionService.isSaving==false
                                                            ?
                                                    'Guardar'
                                                            :
                                                    'Espere',
                  style: TextStyle( color: Colors.white ),
                )
              ),
              onPressed: () async{

                if(selectedProduct!=null){
                    if (selectedProduct!.amount<transaccion.amount){

                       await NotificationService.ShowSnackBar("No hay disponibles en el inventario");
                         Navigator.pushReplacementNamed(context,'transaccion',arguments: [bussinesToken,productsService,selectedProduct]);

                    }else{


                      selectedProduct!.amount=selectedProduct!.amount-transaccion.amount;
                      transaccion.concept=selectedProduct!.name;

                      if(transaccion.type=='Gain'){
                        transaccion.value=selectedProduct!.sellPrice!;


                      }else{
                         transaccion.value=selectedProduct!.buyPrice!;
                      }
                      
                     await  productsService!.updateProduct(selectedProduct!);
                     await transaccionService.saveOrCreateTransaccion(transaccion);

                      Navigator.pushReplacementNamed(context,'home');

                   

                    }
                }else{

                    await transaccionService.saveOrCreateTransaccion(transaccion);
                     Navigator.pushReplacementNamed(context,'home');
                }

                  
                 

                
              },
              ),




              ],
            )
      ),
          ),
        ),
    ]
   )
 )

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