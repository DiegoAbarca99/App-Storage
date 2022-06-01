import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:productos_app/screens/login_screen.dart';

import 'package:provider/provider.dart';
import 'package:productos_app/providers/product_form_provider.dart';

import 'package:productos_app/services/services.dart';

import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';


class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: ( _ ) => ProductFormProvider( productService.selectedProduct! ),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.only(top:50),
          child: Column(
            children: [
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: _columnDecoration(),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Stack(
                        children: [
                  
                          ProductImage( url: productService.selectedProduct!.picture ),
                  
                          Positioned(
                            top: 5,
                            left: 5,
                            child: IconButton(
                              onPressed: () => Navigator.of(context).pop(), 
                              icon: Icon( Icons.arrow_back_ios_new, size: 30, color: Colors.white ),
                            )
                          ),
                        
                          Positioned(
                            top: 5,
                            right: 20,
                            child: IconButton(
                              onPressed: () async {
                                
                                final picker = new ImagePicker();
                                final PickedFile? pickedFile = await picker.getImage(
                                  // source: ImageSource.gallery,
                                  source: ImageSource.camera,
                                  imageQuality: 100
                                );
                        
                                if( pickedFile == null ) {
                                  print('No seleccionó nada');
                                  return;
                                }
                        
                                productService.upDateSelectedProductImage(pickedFile.path);
                                
                        
                              }, 
                              icon: Icon( Icons.camera_alt_outlined, size: 30, color: Colors.white ),
                            )
                          )
                        ],
                      ),
                        
                      

                      Container(
                        width: 140,
                        height:250 ,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            SizedBox(height: 20,),
                        
                            Text('Código',style: TextStyle(fontSize:20 ,fontWeight: FontWeight.bold),),
                        
                            SizedBox(height: 5,),
                        
                             _CustomInput(productForm: productForm),
                        
                            SizedBox(height: 10,),
                        
                             Text('Cantidad',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        
                            SizedBox(height: 5,),

                            _CustomBottoms(productForm: productForm,)

                        
                        
                        
                            ],
                        ),
                      ),
                        
                        
                        
                        
                    ],
                  ),
                ),
              ),
          
                
          
              _ProductForm(),
          
              SizedBox( height: 100 ),
          
            ],
          ),
        ),
      ),

      
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: productService.isSaving 
          ? CircularProgressIndicator( color: Colors.white )
          : Icon( Icons.save_outlined ),
        onPressed: productService.isSaving 
          ? null
          : () async {
          
          if ( !productForm.isValidForm() ) return;

          final String? imageUrl = await productService.uploadImage();

          if ( imageUrl != null ) productForm.product.picture = imageUrl;

          //await productService.saveOrCreateProduct(productForm.product);
          Future.microtask(()async {
               await Provider.of<AuthService>(context,listen:false).deleteUser();
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_,__,___)=>LoginScreen(),
                  transitionDuration: Duration(seconds: 0)
                  ));;

          });
          //await Provider.of<AuthService>(context,listen:false).deleteUser();
          //Navigator.pushReplacementNamed(context, 'login');

        },
      ),
   );
  }

  BoxDecoration _columnDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5

      )
    ]
  );

}



class _CustomBottoms extends StatelessWidget {

  final ProductFormProvider productForm;

  const _CustomBottoms({
    Key? key, required this.productForm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

   
    
    return Row(
      children: [


         Container(
           decoration:_customButton(),
           child: IconButton(onPressed: (){

            productForm.decreaseAmount();
            print(productForm.product.amount);
           }, icon: Icon(Icons.exposure_minus_1_outlined)),
         ),


         Container(
           height:48,
           alignment: Alignment(50, 0),
           decoration: _textDecoration(),
           child: Text(productForm.product.amount.toString()
           )),


        Container(
          decoration: _customButton2(),
          child: IconButton(onPressed: (){

            productForm.increaseAmount();
          }, icon: Icon(Icons.plus_one_outlined)),
        ),

        
      ],
    );
  }

  BoxDecoration _textDecoration() => BoxDecoration(
     color: Colors.black.withOpacity(0.10),
     
      boxShadow:[
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5

      )
    ]

  );

  BoxDecoration _customButton2() => BoxDecoration(
    borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
    color: Colors.black.withOpacity(0.10),
    boxShadow:[
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5

      )
    ]
  );



  BoxDecoration _customButton() => BoxDecoration(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
    color: Colors.black.withOpacity(0.10),
    boxShadow:[
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5

      )
    ]
  );
}

class _CustomInput extends StatelessWidget {
  const _CustomInput({
    Key? key,
    required this.productForm,
  }) : super(key: key);

  final ProductFormProvider productForm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
    
    
        Expanded(
          child: TextFormField(
            initialValue: productForm.product.qrCode,
             keyboardType: TextInputType.text,
             decoration: InputDecorations.authInputDecoration(
             hintText:'Ingrese el Código' ,
              labelText: 'Código QR', 
            ),
            onChanged: (value){
              productForm.product.qrCode=value;
            },
            
            
          ),
        ),
    
    
        IconButton(
          onPressed: ()async {
            String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                      '#3D88EF', 
                                      'Cancelar', 
                                      false, 
                                      ScanMode.QR);
             print(barcodeScanRes);
    
            if(barcodeScanRes=='-1'){
               return;
             }
             
             productForm.product.qrCode=barcodeScanRes;
             Navigator.pushNamed(context, 'product');
        }, 
        icon: Icon(Icons.qr_code_scanner))
      ],
    );
  }
}

class _ProductForm extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [

              SizedBox( height: 10 ),

              TextFormField(
                initialValue: product.name,
                onChanged: ( value ) => product.name = value,
                validator: ( value ) {
                  if ( value == null || value.length < 1 )
                    return 'El nombre es obligatorio'; 
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto', 
                  labelText: 'Nombre:'
                ),
              ),

              SizedBox( height: 30 ),

              TextFormField(
                initialValue: '${product.sellPrice}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: ( value ) {
                  if ( double.tryParse(value) == null ) {
                    product.sellPrice = 0;
                  } else {
                    product.sellPrice = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Ingrese un valor', 
                  labelText: 'Valor de Venta:'
                ),
              ),
              
              SizedBox( height: 30 ),

                TextFormField(
                initialValue: '${product.buyPrice}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: ( value ) {
                  if ( double.tryParse(value) == null ) {
                    product.buyPrice = 0;
                  } else {
                    product.buyPrice = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Ingrese un valor', 
                  labelText: 'Valor de Compra:'
                ),
              ),

              SizedBox( height: 30 ),



            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only( bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5
      )
    ]
  );
}