import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/search/transaccion_search_delegate.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class BalanceScreen extends StatelessWidget {
  final BussinesService bussinesService;
  final Bussines selectedBussines;
  final String bussinesToken;
  

  const BalanceScreen({Key? key,required this.selectedBussines,required this.bussinesToken,required this.bussinesService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    final transaccionsService=Provider.of<TransaccionsService>(context);
    final transaccions=transaccionsService.transaccions;
    final productsService=Provider.of<ProductsService>(context);

    List<double> multiplicationGain=[];
    List<double> multiplicationLoss=[];
    double gainings=0;
    double losses=0;
    double utility=0;

                    for (var i = 0; i < transaccions.length; i++) {
                        if(transaccions[i].type=='Gain'){
                           multiplicationGain.add(transaccions[i].amount*transaccions[i].value);
                        }
                    }

                    for (var i = 0; i < transaccions.length; i++) {
                        if(transaccions[i].type=='loss'){
                           multiplicationLoss.add(transaccions[i].amount*transaccions[i].value);
                        }
                    }


                    
                    for (int i = 0; i < multiplicationGain.length; i++) {
                        
                        gainings=gainings+multiplicationGain[i];
                    }

                      for (int i = 0; i < multiplicationLoss.length; i++) {
                        
                        losses=losses+multiplicationLoss[i];
                    }

                    utility=gainings-losses;

    


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: SingleChildScrollView(
        child: Column(

          children:[

            Container(
              decoration:_buildBoxDecoration(),
              height: size.height*0.2,
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    width:size.width*0.45,
                    alignment: AlignmentDirectional.center,

                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Utilidades",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                          SizedBox(height:5),

                          utility<0
                          ?
                          Text("\$ $utility",style: TextStyle(color: Colors.red),)
                          :
                           Text("\$ $utility",style: TextStyle(color: Colors.green),)
                        ],
                      ),
                    )
                    ),
                    
                    VerticalDivider(color: Colors.black,),

                    Container(
                      width: size.width*0.38,
                      padding: EdgeInsets.only(bottom:10,top: 10),
                      child:Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Text("Ganancias",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color:Colors.green) ,),

                 

                          Text("\$ $gainings",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color:Colors.green) ,),

                          Divider(color:Colors.black),


                          Text("Perdidas",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color:Colors.red) ,),


                          Text("\$ $losses",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color:Colors.red) ,),

                        ],
                      )
                    )

                ],),
            ),

            SizedBox(height: 5,),



              Padding(
          padding: const EdgeInsets.symmetric(horizontal:10,vertical: 15),
          child: Container(
            padding:EdgeInsets.symmetric(horizontal: 10),
            decoration: _buildBoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              child: MaterialButton(
                onPressed: () async {
                  
                 
                showSearch(context: context, delegate: TransaccionSearchDelegate(transaccionsSearch:await transaccionsService.searchTransaccions(), bussinesService: bussinesService, bussinesToken: bussinesToken, selectedBussines: selectedBussines));

                },
                child: Row(
                  children: [
                    Icon(Icons.search,color: Colors.indigo,),
                    Text("Buscar transacción",style: Theme.of(context).textTheme.caption,),
                  ],
                ),
                ),
            ),
          ),
        ),



               AppBackground(
               widget: ListView.builder(
                itemCount: transaccionsService.transaccions.length,
                itemBuilder: ( BuildContext context, int index ) {

                  
                  

                    return GestureDetector(
                      onTap: () {
                       
                         
                        Provider.of<SelectedTransaccion>(context,listen: false).selectedTransaccion = transaccionsService.transaccions[index].copy();
                        Navigator.pushNamed(context, 'viewtransaccion',arguments:[bussinesToken,productsService,null]);
                    },
                      child: TransaccionCard(transaccion: transaccionsService.transaccions[index]),
                 );
                  
                } 
              ),
            ),

             SizedBox(height: 10,),

             MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
              color: Colors.indigo,
              child: Container(
                padding: EdgeInsets.symmetric( horizontal: 40, vertical: 10),
                child: Text( 'Agregar una transacción',
                  style: TextStyle( color: Colors.white ),
                )
              ),
              onPressed:() async {


                Provider.of<SelectedTransaccion>(context,listen: false).selectedTransaccion= new Transaccion(
                 concept: '', 
                 type: 'Gain', 
                 value: 0, 
                 paymentMethod:'Efectivo', 
                 amount: 0, 

                );

               

          
            Navigator.pushNamed(context, 'transaccion',arguments: [bussinesToken,productsService,null]);
          }
        )




            




             
          ]
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