import 'dart:async';
import 'package:flutter_app_2210/charts/RSSIGauge.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app_2210/globalvar.dart';
import 'package:intl/intl.dart';

class StaticTempChart extends StatefulWidget {
  final int chartDataFirst;

  const StaticTempChart({Key key, this.chartDataFirst}) : super(key: key);

  @override
  _StaticTempChartState createState() => _StaticTempChartState();
}

class _StaticTempChartState extends State<StaticTempChart> with AutomaticKeepAliveClientMixin{

  List<SensirionData> chartData = [];
  Future _future;
  num sum = 0;
  String avg;

  Future loadData() async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String responseBody = response.body;
      var jsonBody = json.decode(responseBody);
      for (Map data in jsonBody) {
        setState(() {
          chartData.add(
              new SensirionData.fromJson(data)); // Deserialization step #3
        });
      }
      return chartData.last;
    } else {
      print('Something went wrong');
    }
  }

  @override
  void initState() {
    super.initState();
    _future = loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    return Material(
        color: scaffoldColor,
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  _statHumidityLine(),
                  Container(
                      margin: EdgeInsets.only(right: 5, left: 5, top: 10),
                      height: size.height*0.2,
                      child: Row(
                        children: [
                          Expanded(child: _avgTempCard()),
                          Expanded(child: _moreInfoCard()),
                        ],
                      )),
                ],
              );
            } else return Center(child: CircularProgressIndicator());
          },
        )
    );
  }

  Widget _avgTempCard() {
    sum = 0;
    (chartData.getRange((chartData.length - widget.chartDataFirst), (chartData.length))).forEach((e) => sum += e.sen2);
    avg = (sum / widget.chartDataFirst).toStringAsPrecision(4);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      color: cardColors,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Average Temp",
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 18,
                  color: accentColor,
                  fontWeight: FontWeight.normal,
              )
          ),
          Text("$avg°C",
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 20,
                  color: mainTextColor,
                  fontWeight: FontWeight.normal)),
          SizedBox(),
        ],
      ),
    );
  }

  Widget _moreInfoCard() {
    sum = 0;
    (chartData.getRange((chartData.length - widget.chartDataFirst), (chartData.length))).forEach((e) => sum += e.sen1);
    avg = (sum / widget.chartDataFirst).toStringAsPrecision(4);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      color: cardColors,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Latest Temp",
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 18,
                  color: accentColor,
                  fontWeight: FontWeight.normal)),
          Text("${chartData.last.sen2}°C",
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 20,
                  color: mainTextColor,
                  fontWeight: FontWeight.normal)),
          SizedBox(),
        ],
      ),
    );
  }

  Widget _statHumidityLine() {
    return Container(
        width: (
            (MediaQuery.of(context).orientation == Orientation.landscape)
                ? (MediaQuery.of(context).size.width) * 0.5
                : (MediaQuery.of(context).size.width) * 1),
        height:(
            (MediaQuery.of(context).orientation == Orientation.portrait)
                ? (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight - kToolbarHeight - kBottomNavigationBarHeight) * 0.55
                : (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight - kToolbarHeight - kBottomNavigationBarHeight) * 0.75),
        child:SfCartesianChart(
              backgroundColor: Colors.transparent,
              plotAreaBorderWidth: 0,
              zoomPanBehavior: ZoomPanBehavior(enablePanning: true, enablePinching: true, zoomMode: ZoomMode.xy),
              margin: EdgeInsets.all(5),
              primaryXAxis: CategoryAxis(
                edgeLabelPlacement: EdgeLabelPlacement.hide,
                labelPlacement: LabelPlacement.onTicks,
                labelAlignment: LabelAlignment.start,
                majorGridLines: MajorGridLines(width: 0),
                majorTickLines: MajorTickLines(size: 4, width: 2),
              ),
              primaryYAxis: NumericAxis(
                  anchorRangeToVisiblePoints: true,
                  axisLine: AxisLine(width: 0, color: Colors.transparent),
                  labelAlignment: LabelAlignment.start,
                  labelPosition: ChartDataLabelPosition.inside,
                  edgeLabelPlacement: EdgeLabelPlacement.hide,
                  majorTickLines: MajorTickLines(size: 0, width: 0),
                  majorGridLines: MajorGridLines(width: 1),
                  minorGridLines: MinorGridLines(width: 0.0),
                  desiredIntervals: 3,
                  decimalPlaces: 1,
                  // '%' will be append to all Y-axis labels
                  labelFormat: '{value}°C'
              ),
              //Enable legend
              legend: Legend(isVisible: false),
              //Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<SensirionData, String>>[
                LineSeries<SensirionData, String>(
                  name: 'Temperature Trends',
                  color: chartColors,
                  dataSource:((chartData.getRange((chartData.length - widget.chartDataFirst), (chartData.length))).toList()),
                  xValueMapper: (SensirionData data, _) => data.date,
                  yValueMapper: (SensirionData data, _) => data.sen2,
                  //Enable Label Settings
                  dataLabelSettings: DataLabelSettings(isVisible: false),
                  markerSettings: MarkerSettings(isVisible: false),
                ),
              ]
          ),
        );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
