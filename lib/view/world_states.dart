import 'package:covid/Model/WorldStatesModel.dart';
import 'package:covid/Services/states_services.dart';
import 'package:covid/view/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen> with TickerProviderStateMixin{


  late final AnimationController _controller=AnimationController(
      duration:const Duration(seconds: 3),vsync: this)..repeat();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  final colorList=<Color>
  [
    const Color(0xff4285F4),
   const Color(0xff1aa268),
    const Color(0xffde5246),
  ];
  @override
  Widget build(BuildContext context) {
    StatesServices statesServices =StatesServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*.01,
              ),
              FutureBuilder(
                  future: statesServices.fetchWorldStatesRecords(),
                  builder: (context,AsyncSnapshot<WorldStatesModel> snapshot){

                if(!snapshot.hasData){
                  return Expanded(
                      flex: 1,
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50,
                        controller: _controller,
                      ));
                }
                else{
                      return Column(
                        children: [
                          PieChart(dataMap:
                          {
                            "Total": double.parse(snapshot.data!.cases!.toString()),
                "Recovered": double.parse(snapshot.data!.recovered.toString()),
                "Deaths": double.parse(snapshot.data!.deaths.toString()),


                          },
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true
                            ),
                            chartRadius: 150,
                            legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.left
                            ),
                            animationDuration:const Duration(microseconds: 1200),
                            chartType: ChartType.ring,
                            colorList: colorList,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*.06,),
                            child: Card(
                              child: Column(
                                children: [
                                  ReusableRow(title: 'Total', value: snapshot.data!.cases!.toString()),
                                  ReusableRow(title: 'Recovered', value: snapshot.data!.recovered!.toString()),
                                  ReusableRow(title: 'Deaths', value: snapshot.data!.deaths!.toString()),
                                  ReusableRow(title: 'Tests', value: snapshot.data!.tests!.toString()),
                                  ReusableRow(title: 'AffetedCountries', value: snapshot.data!.affectedCountries!.toString()),

                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=> CountriesListsScreen()));
                            },
                            child: Container(
                              height: 50,
                              decoration:  BoxDecoration(
                                  color: Color(0xff1aa260),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(
                                child: Text('Track Countries'),
                              ),
                            ),
                          )
                        ],
                      );
                }
              }),

            ],
          ),
        ),
      ),
    );
  }
}
class ReusableRow extends StatelessWidget {
  String title ,value;
   ReusableRow({super.key,required this.title,required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,right: 10,top: 10,bottom: 10
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value)
            ],
          ),
          SizedBox(
          height: 5,
          ),
          Divider()
        ],
      ),
    );
  }
}

