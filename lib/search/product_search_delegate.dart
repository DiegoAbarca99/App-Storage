import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';



class ProductSearchDelegate extends  SearchDelegate{

  List<Product> _filter=[];

  List<Product> productsSearch;
  BussinesService bussinesService;
  String bussinesToken;
  Bussines selectedBussines;


  ProductSearchDelegate({required this.productsSearch,required this.bussinesService,required this.bussinesToken,required this.selectedBussines});

  @override
  String? get searchFieldLabel => 'Buscar producto';


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
        IconButton(onPressed: (){
      query='';
    }

    , icon: const Icon(Icons.clear))

    ];
  
  }

  @override
  Widget? buildLeading(BuildContext context) {
      return IconButton(onPressed: (){
        close(context, null);
      }, icon:const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  Widget _emptyContainer(){
    return Container(
        child:const Center(
            child: Icon(Icons.view_in_ar_outlined,color:Colors.black38,size:130)
        )
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    if( query.isEmpty ) {
        return _emptyContainer();
      }


      _filter=productsSearch.where((product) {
         return product.name.toLowerCase().contains(query.trim().toLowerCase());
      }).toList();

      print('Lista filtrada: $_filter');
      print('Productos del search: $productsSearch');


      return AppBackground(
               widget: ListView.builder(
                itemCount: _filter.length,
                itemBuilder: ( BuildContext context, int index ) {

                    return GestureDetector(
                      onTap: () {
                        Provider.of<SelectedProduct>(context,listen: false).selectedProduct = _filter[index].copy();
                        Navigator.pushNamed(context, 'viewproduct',arguments: [bussinesService,bussinesToken,selectedBussines]);
                    },
                      child: ProductCard(product: _filter[index]),
                 );
                  
                } 
              ),
            );
           

       
  }
  


}

