import 'package:final_fetcj/feedback_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'dart:convert'as convert;
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late List <SalesData> _chartData;
  late TooltipBehavior _tooltipBehavior;


  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<FeedbackModel> feedbacks = <FeedbackModel>[];

  getFeedbackFromSheet() async{

    var raw = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbz4mVqsXrtJPQIeZhhjO3SCWu0ZwRt0caZSM-wKklXJfh8-o6x8poQmk6LRwV-PBC8_Tg/exec'));

    var jsonFeedback = convert.jsonDecode(raw.body);
    print("this is json feedback  $jsonFeedback");

    //feedbacks = jsonFeedback.map((json)=> FeedbackModel.fromJson(json));
    //print("${feedbacks[0]}");

    //error happening here due to initialization with hardcoded values.
    jsonFeedback.forEach((element){
      print('$element This is NEXT>>>>>>');

      FeedbackModel feedbackModel = new FeedbackModel(a:"hardcoded1" ,b:"hardcoded2",c: "hardcoded3",d: "hardcoded4");

      //FeedbackModel feedbackModel = new FeedbackModel();

      feedbackModel.a= element['a'];
      feedbackModel.b= element['b'];
      feedbackModel.c= element['c'];
      feedbackModel.d= element['d'];

      feedbacks.add(feedbackModel);
      print("length of FEEDBACKS: ${feedbacks.length.toString()}");
    });
  }

  @override
  void initState() {

    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    getFeedbackFromSheet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          title: Text("fight"),
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfCartesianChart(
                  title: ChartTitle(text:"ZGraph"),
                  //legend: Legend(isVisible: true),
                  tooltipBehavior: _tooltipBehavior,
                  series: <ChartSeries>[
                    LineSeries<SalesData,double>(
                      name: "Stock Variations",
                      dataSource: _chartData,
                      xValueMapper: (SalesData sales,_) => sales.year,
                      yValueMapper: (SalesData sales,_) => sales.sales,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      enableTooltip: true,
                    ),
                  ],
                  primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
                  primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat.simpleCurrency(decimalDigits:0)),
                ),
              ),
            ),
            Container(
              child: ListView.builder(
                itemCount: feedbacks.length,
                itemBuilder: (context,index){
                  return FeedbackTile(a: feedbacks[index].a,b: feedbacks[index].b,c: feedbacks[index].c,d: feedbacks[index].d,);
                  //return FeedbackTile(a: feedbacks[index].a, b: feedbacks[index].b, c: feedbacks[index].c, d: feedbacks[index].d);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  List<SalesData> getChartData(){
    final List<SalesData> chartData = [
      //SalesData(2014, double.parse(feedbacks.single.a)),
      SalesData(2015, 25),
      SalesData(2016, 17),
      SalesData(2017, 12),
      SalesData(2018, 16),
      SalesData(2019, 19),
      //SalesData(2020, double.parse(feedbacks[0].c)),
    ];
    return chartData;
  }

}

class FeedbackTile extends StatelessWidget {

  final String a,b,c,d;

  FeedbackTile({required this.a,required this.b,required this.c,required this.d});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
            Row( children: [
              Text("$a"),
            ],
            ),
            Row( children: [
              Text("$b"),
            ],
            ),
            Row( children: [
              Text("$c"),
            ],
            ),
            Row( children: [
              Text("$d"),
            ],
            ),
        ],
      ) ,
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final double year;
  final double sales;
}
