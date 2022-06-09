import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductCard extends StatelessWidget {

     final Product product;

  const ProductCard({Key? key,required this.product}) : super(key: key);

   


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
      child: Container(

        decoration: _buildBoxDecoration(),
        width: double.infinity,
        height: 100,
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal:10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(product.name,style:Theme.of(context).textTheme.headline6,),

                  SizedBox(height: 5,),

                  Text(product.amount==0
                      ?'No disponible'
                      :'${product.amount.toString()} Disponible',
                      style:Theme.of(context).textTheme.caption ,
                      ),

                  SizedBox(height: 5),

                  Text('\$ ${product.sellPrice.toString()}')
              ],),
              

              _ProductImage(product.picture),
            ]),
        
      ),
     ),
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


class _ProductImage extends StatelessWidget {
 
  final String? url;

  const _ProductImage( this.url );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 50,
        height: 50,
        child: url == null
          ? Image(
              image: AssetImage('assets/no-image.png'),
              fit: BoxFit.cover
            )
          : FadeInImage(
            placeholder: AssetImage('assets/jar-loading.gif'),
            image: NetworkImage(url!),
            fit: BoxFit.cover,
          ),
      ),
    );
  }
}