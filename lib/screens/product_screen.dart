import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:productos_app/providers/selected_product.dart';
import 'package:productos_app/screens/login_screen.dart';

import 'package:provider/provider.dart';
import 'package:productos_app/providers/product_form_provider.dart';

import 'package:productos_app/services/services.dart';

import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';


class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);


    return ChangeNotifierProvider(
      create: ( _ ) => ProductsService(userToken:authService.userToken ),
      child:_ProducsScreenAssistant());
    
  }
}

class _ProducsScreenAssistant extends StatelessWidget {
  const _ProducsScreenAssistant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductsService>(context);
    final selectedProduct=Provider.of<SelectedProduct>(context).selectedProduct;
    productService.selectedProduct=selectedProduct!;

    print('respuesta del product Screen: `${productService.selectedProduct}`');
    return  ChangeNotifierProvider(
      create: ( _ ) => ProductFormProvider( productService.selectedProduct),
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
      appBar: AppBar(
          title:Text('Editar-Producto'),
          centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            Container(
              decoration: _columnDecoration(),
              width: double.infinity,
              child: Row(
                children: [
                  Stack(
                    children: [
              
                      ProductImage( url: productService.selectedProduct.picture ),
              
                    
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
                    height:200 ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
            
            
                        SizedBox(height: 20,),
                    
                        Text('Código',style: TextStyle(fontSize:20 ,fontWeight: FontWeight.bold),),
                    
                        SizedBox(height: 5,),
                    
                         _CustomInputQR(productForm: productForm),
                    
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
        
              
        
            _ProductForm(productService:productService),
        
            
          ],
        ),
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

class _CustomInputQR extends StatelessWidget {
  const _CustomInputQR({
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

    final ProductsService productService;

    _ProductForm({required this.productService});

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Container(
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
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Ingrese un valor', 
                labelText: 'Valor de Compra:'
              ),
            ),
              
            SizedBox( height: 15 ),

              TextFormField(

              initialValue: product.description,
              onChanged: ( value ) => product.description = value,
                
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Descripción del producto (opcional)', 
                labelText: 'Descripción (opcional):'
              ),
            ),

             SizedBox( height: 15 ),
            
             Container(
            padding:const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                   onPressed:
                    Provider.of<SelectedProduct>(context,listen: false).isSelected==false
                    ?
                    null
                    :
                     productService.isDeleting==true
                    ?null
                    :() {
                      
                      Navigator.pushReplacementNamed(context, 'warning',arguments: productForm.product);
                    },
                   child:Container(
                     padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
                     decoration: _boxDecorationDelete(color:Colors.red),
                     child: Text(
                       Provider.of<SelectedProduct>(context).isSelected==false
                       ?
                       'Deshabilitado'
                       :
                       productService.isDeleting==true
                       ?'Espere'
                       :'Eliminar',style: TextStyle(color: Colors.white),),
                   ) 
                 ),
            
                SizedBox(width: 20,),
            
                 TextButton(
                   child: Container(
                    padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
                     decoration: _boxDecorationDelete(color: Colors.indigo),
                     child: Text(
                         productService.isDeleting==true
                         ?'Espere'
                         :'Guardar',style: TextStyle(color: Colors.white),),
                   ),
                   onPressed: productService.isSaving 
                   ? null
                   : () async {
            
                   if ( !productForm.isValidForm() ) return;
            
                   final String? imageUrl = await productService.uploadImage();
            
                   if ( imageUrl != null ) productForm.product.picture = imageUrl;
            
                   await productService.saveOrCreateProduct(productForm.product);
                   Navigator.pushReplacementNamed(context, 'home');
                  },
                 )
              ],
            ),
          ),
              
              
              
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5
      )
    ]
  );


  

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

}