import 'dart:async';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app_2210/globalvar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app_2210/localNotificationhelper.dart';
import 'package:flutter_app_2210/aboutspage.dart';
import 'package:async/async.dart';

class MovingRealHumidityChart extends StatefulWidget {
  @override
  _MovingRealHumidityChartState createState() => _MovingRealHumidityChartState();
}

class _MovingRealHumidityChartState extends State<MovingRealHumidityChart> with AutomaticKeepAliveClientMixin{
  final notifications = FlutterLocalNotificationsPlugin();
  List<SensirionData> chartData = [];
  num sum = 0;
  String avg;
  Timer _loadTimer;
  bool loading = true;
  RestartableTimer timer;
  int cd = 0;

  _MovingRealHumidityChartState() {
    _loadTimer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      loadSensorData();
      /*if (chartData.last.sen1 > 30) {
        if (timer?.isActive ?? false) {
          cd ++;
          print(cd);
        } else {
          timer = RestartableTimer(Duration(seconds: 180), popNotification());
          print('30s has passed');
        }
      }*/
    });
  }

  popNotification() {
    showOngoingNotification(notifications, title: 'Alert',
        body: 'Current Humidity is ${chartData.last.sen2}!');
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
        child: (loading == false)
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
          Text("Average Humidity",
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 18,
                  color: accentColor,
                  fontWeight: FontWeight.normal)),
          Text("$avg%",
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
          Text("Current Humidity",
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 18,
                  color: accentColor,
                  fontWeight: FontWeight.normal)),
          Text("${chartData.last.sen1}%",
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
        child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              enableAxisAnimation: false,
              zoomPanBehavior: ZoomPanBehavior(enablePanning: true, enablePinching: true),
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
                  axisLine: AxisLine(width: 0, color: Colors.transparent),
                  anchorRangeToVisiblePoints: true,
                  labelAlignment: LabelAlignment.start,
                  labelPosition: ChartDataLabelPosition.inside,
                  edgeLabelPlacement: EdgeLabelPlacement.hide,
                  majorTickLines: MajorTickLines(size: 1),
                  majorGridLines: MajorGridLines(width: 1),
                  minorGridLines: MinorGridLines(width: 0.0),
                  desiredIntervals: 2,
                  decimalPlaces: 1,
                  // '%' will be append to all Y-axis labels
                  labelFormat: '{value}%'
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
                  yValueMapper: (SensirionData data, _) => data.sen1,
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