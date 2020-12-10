import 'dart:async';
import 'package:async/async.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app_2210/globalvar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app_2210/localNotificationhelper.dart';
import 'package:flutter_app_2210/aboutspage.dart';


class MovingRealTempChart extends StatefulWidget {
  @override
  _MovingRealTempChartState createState() => _MovingRealTempChartState();
}

class _MovingRealTempChartState extends State<MovingRealTempChart> with AutomaticKeepAliveClientMixin{
  final notifications = FlutterLocalNotificationsPlugin();
  List<SensirionData> chartData = [];
  num sum = 0;
  String avg;
  Timer _loadTimer;
  RestartableTimer timer;
  bool loading = true;
  int cd = 0;

  _MovingRealTempChartState() {
    _loadTimer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      loadSensorData();
      if (chartData.last.sen2 > 28.1) {
        if (timer?.isActive ?? false) {
          cd ++;
          print(cd);
        } else {
          timer = RestartableTimer(Duration(seconds: 180), popNotification());
          print('3m has passed');
        }
      }
    });
  }

  popNotification() {
    showOngoingNotification(notifications, title: 'Alert',
        body: 'Current Temperature is ${chartData.last.sen2}!');
  }

  Future onSelectNotification(String payload) async => await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AboutsPage(payload: payload)),
  );


  Future<String> getChartJsonFromDatabase() async {
    // Sending get(url) request using the http client to retrieve the response.
    var response = await http.get(singleUrl);
    return response.body;
  }

  Future loadSensorData() async {
    String jsonString = await getChartJsonFromDatabase(); // Deserialization Step #1
    final jsonResponse = json.decode(jsonString); // // Deserialization Step #2

    if (this.mounted == true) {
      setState(() {
        // Mapping the retrieved json response string and adding the sensor data to the chart data list.
        for (Map i in jsonResponse) {
          chartData.add(
              SensirionData.fromJson(i) // Deserialization step #3
          );
          loading = false;
        }
        
      }
      );
    }
  }

  @override
  void initState() {
    loadSensorData();
    super.initState();
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));
    notifications.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  @override
  void dispose() {
    _loadTimer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery
        .of(context)
        .size;
    return Material(
        color: scaffoldColor,
        child: (loading == false )
            ? Column(
          children: [
            _movingTempLine(),
            Container(
                margin: EdgeInsets.only(right: 5, left: 5, top: 10),
                height: size.height * 0.2,
                child: Row(
                  children: [
                    Expanded(child: _avgTempCard()),
                    Expanded(child: _moreInfoCard()),
                  ],
                )
            ),
          ],
        ) : Center(child: CircularProgressIndicator())
    );
  }

  Widget _avgTempCard() {
    sum = 0;
    (chartData).forEach((e) => sum += e.sen2);
    avg = (sum / chartData.length).toStringAsPrecision(4);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      color: cardColors,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Average",
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 18,
                  color: accentColor,
                  fontWeight: FontWeight.normal)),
          Text("$avg°C",
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 20,
                  color: mainTextColor,
                  fontWeight: FontWeight.normal)),
          Text(""),
        ],
      ),
    );
  }

  Widget _moreInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      color: cardColors,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Current",
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 18,
                  color: accentColor,
                  fontWeight: FontWeight.normal)),
          Text("${chartData.last.sen2}°C",
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.normal)),
          Text(""),
        ],
      ),
    );
  }

  Widget _movingTempLine() {
    return Container(
        width: ((MediaQuery.of(context).orientation == Orientation.landscape)
            ? (MediaQuery.of(context).size.width) * 0.5
            : (MediaQuery.of(context).size.width) * 1),
        height: ((MediaQuery.of(context).orientation == Orientation.portrait)
            ? (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight - kToolbarHeight - kBottomNavigationBarHeight) * 0.55
            : (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight - kToolbarHeight - kBottomNavigationBarHeight) * 0.75),
        child:SfCartesianChart(
              plotAreaBorderWidth: 0,
              enableAxisAnimation: true,
              zoomPanBehavior: ZoomPanBehavior(enablePanning: true, enablePinching: true, zoomMode: ZoomMode.x),
              margin: EdgeInsets.all(5),
              primaryXAxis: CategoryAxis(
                visibleMinimum: ((chartData.length <= 10) ? 0 : ((chartData.length).toDouble() - 9)),
                visibleMaximum: ((chartData.length - 1).toDouble()),
                edgeLabelPlacement: EdgeLabelPlacement.hide,
                labelPlacement: LabelPlacement.onTicks,
                labelAlignment: LabelAlignment.start,
                labelIntersectAction: AxisLabelIntersectAction.hide,
                majorGridLines: MajorGridLines(width: 0),
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
                  desiredIntervals: 2,
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
                  dataSource: chartData,
                  xValueMapper: (SensirionData data, _) => data.now,
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