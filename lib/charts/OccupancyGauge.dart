import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_2210/globalvar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:convert';

class OccupancyGauge extends StatefulWidget {
  OccupancyGauge({Key key}) : super(key: key);

  @override
  _OccupancyGaugeState createState() => _OccupancyGaugeState();
}

class _OccupancyGaugeState extends State<OccupancyGauge> {

  double lastVal;
  List<dynamic> chartData = []; // list for storing the last parsed Json data
  bool loading = true;
  Timer _loadTimer;


  Future<String> getChartJsonFromDatabase() async {
    // Sending get(url) request using the http client to retrieve the response.
    var response = await http.get(singleUrl);
     return response.body;
  }

  Future loadSensorData() async {
    String jsonString = await getChartJsonFromDatabase(); // Deserialization Step #1
    final jsonResponse = json.decode(jsonString); // // Deserialization Step #2

    if(this.mounted == true){
      setState(() {
        loading = false;
        // Mapping the retrieved json response string and adding the sensor data to the chart data list.
        for (Map i in jsonResponse){
          chartData.add(
              SensorData.fromJson(i) // Deserialization step #3
          );}
        lastVal = double.parse(chartData.last.toString());
      }
      );
    }
  }

  @override
  void initState() {
    loadSensorData();
    _loadTimer = Timer.periodic(Duration(seconds: 8), (Timer t) {
      loadSensorData();
      if (this.mounted == false){
        _loadTimer.cancel();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _loadTimer.cancel();
    super.dispose();
  }

  Widget _buildChild() {
    if (loading == false) {
      return SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 3000,
          title: GaugeTitle(
              text: 'Occupancy',
              textStyle: const TextStyle(
                  fontSize: 20.0, fontWeight: FontWeight.bold)),
          axes: <RadialAxis>[
            RadialAxis(minimum: 0.0, maximum: 1.0, interval: 1, startAngle: 180, endAngle: 360, ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0.0,
                  endValue: 1.0,
                  color: (lastVal == 1) ? Colors.red : Colors.green,
                  startWidth: 10,
                  endWidth: 10),
            ], pointers: <GaugePointer>[
              NeedlePointer(value: (lastVal == 0) ? lastVal + 0.001 : lastVal, enableAnimation: true, animationDuration: 1000)
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                      child: Text((lastVal == 1) ? 'Present' : 'Away',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                  ),
                  angle: 90,
                  positionFactor: 0.5)
            ])
          ]);
    } else return Stack(children:[SfRadialGauge(), Center(child: CircularProgressIndicator())]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      child: _buildChild()
    );
  }

}

class SensorData {
  SensorData(this.sen6);

  dynamic sen6;

  factory SensorData.fromJson(Map<String, dynamic> parsedJson) {
    return SensorData(
      parsedJson['Sen6'] as dynamic,
    );
  }

  @override toString() => '$sen6';
}