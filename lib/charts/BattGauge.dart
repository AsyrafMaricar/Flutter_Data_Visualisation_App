import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_2210/globalvar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:convert';

class BatteryGauge extends StatefulWidget {
  BatteryGauge({Key key}) : super(key: key);

  @override
  _BatteryGaugeState createState() => _BatteryGaugeState();
}

class _BatteryGaugeState extends State<BatteryGauge> {

  List<SensorData> chartData = []; // list for storing the last parsed Json data
  bool loading = true;
  double lastVal;
  Timer _loadTimer;

  Future<String> getChartJsonFromDatabase() async {
    // Sending get(url) request using the http client to retrieve the response.
    var response = await http.get(singleUrl);
    return response.body;
  }

  Future loadSensorData() async {
    String jsonString = await getChartJsonFromDatabase(); // Deserialization Step #1
    final jsonResponse = json.decode(jsonString); // // Deserialization Step #2

    if (this.mounted == true){
      setState(() {
        loading = false;
        // Mapping the retrieved json response string and adding the sensor data to the chart data list.
        for (Map i in jsonResponse){
          chartData.add(
              SensorData.fromJson(i) // Deserialization step #3
          );}
        lastVal = double.parse(chartData.last.sen3.toString());
      }
      );
    }
  }


  @override
  void initState() {
    loadSensorData();
    _loadTimer = Timer.periodic(Duration(seconds: 10), (Timer t) {
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
              text: 'Battery',
              textStyle: const TextStyle(
                  fontSize: 20.0, fontWeight: FontWeight.bold)),
          axes: <RadialAxis>[
            RadialAxis(interval: 20, axisLineStyle: AxisLineStyle(cornerStyle: CornerStyle.bothCurve),minimum: 0, maximum: 100, ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: 35,
                  color: Colors.red,
                  startWidth: 10,
                  endWidth: 10),
              GaugeRange(
                  startValue: 35.1,
                  endValue: 70,
                  color: Colors.orange,
                  startWidth: 10,
                  endWidth: 10),
              GaugeRange(
                  startValue: 70.1,
                  endValue: 100,
                  color: Colors.green,
                  startWidth: 10,
                  endWidth: 10)
            ], pointers: <GaugePointer>[
              NeedlePointer(value: lastVal + 0.01, enableAnimation: true, animationDuration: 1000)
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                      child: Text('$lastVal%',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                  ),
                  angle: 90,
                  positionFactor: 0.75)
            ])
          ]);
    } else return Stack(children:[SfRadialGauge(), Center(child: CircularProgressIndicator())]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 280, //MediaQuery.of(context).size.height * 0.35,
        child: _buildChild()
    );
  }

}

class SensorData {
  SensorData(this.sen3);

  dynamic sen3;

  factory SensorData.fromJson(Map<String, dynamic> parsedJson) {
    return SensorData(
      parsedJson['Sen3'] as dynamic,
    );
  }

  @override toString() => '$sen3';
}