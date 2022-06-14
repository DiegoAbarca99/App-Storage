import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';



class TransaccionSearchDelegate extends  SearchDelegate{

  List<Transaccion> _filter=[];

  List<Transaccion> transaccionsSearch;
  BussinesService bussinesService;
  String bussinesToken;
  Bussines selectedBussines;


  TransaccionSearchDelegate({required this.transaccionsSearch,required this.bussinesService,required this.bussinesToken,required this.selectedBussines});

  @override
  String? get searchFieldLabel => 'Buscar transacción';


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


      _filter=transaccionsSearch.where((transaccion) {
         return transaccion.concept!.toLowerCase().contains(query.trim().toLowerCase());
      }).toList();

      print('Lista filtrada: $_filter');
      print('Transacciones del search: $transaccionsSearch');


      return SearchBackground(
               widget: ListView.builder(
                itemCount: _filter.length,
                itemBuilder: ( BuildContext context, int index ) {

                    return GestureDetector(
                      onTap: () {
                        Provider.of<SelectedTransaccion>(context,listen: false).selectedTransaccion = _filter[index].copy();
                        Navigator.pushNamed(context, 'viewtransaccion',arguments: [bussinesService,bussinesToken,selectedBussines]);
                    },
                      child: TransaccionCard(transaccion: _filter[index]),
                 );
                  
                } 
              ),
            );
           

       
  }
  


}

