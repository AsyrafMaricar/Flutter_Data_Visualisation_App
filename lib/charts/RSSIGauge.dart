import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_2210/globalvar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:convert';

class RSSIGauge extends StatefulWidget {
  RSSIGauge({Key key}) : super(key: key);

  @override
  _RSSIGaugeState createState() => _RSSIGaugeState();
}

class _RSSIGaugeState extends State<RSSIGauge> {

  List<SensirionData> chartData = []; // list for storing the last parsed Json data
  bool loading = true;
  double lastVal;
  Timer _loadTimer;

  _RSSIGaugeState() {
    _loadTimer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      loadSensorData();
    });
  }

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
              SensirionData.fromJson(i) // Deserialization step #3
          );}
        lastVal = double.parse(chartData.last.sen4.toString());
      }
      );
    }
  }


  @override
  void initState() {
    loadSensorData();
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
              text: 'Signal Strength',
              textStyle: const TextStyle(
                  fontSize: 20.0, fontWeight: FontWeight.bold)),
          axes: <RadialAxis>[
            RadialAxis(axisLineStyle: AxisLineStyle(cornerStyle: CornerStyle.bothCurve),minimum: -110, maximum: -30, ranges: <GaugeRange>[
              GaugeRange(
                  startValue: -110,
                  endValue: -90,
                  color: Colors.red,
                  startWidth: 10,
                  endWidth: 10),
              GaugeRange(
                  startValue: -89.9,
                  endValue: -60,
                  color: Colors.orange,
                  startWidth: 10,
                  endWidth: 10),
              GaugeRange(
                  startValue: -59.9,
                  endValue: -30,
                  color: Colors.green,
                  startWidth: 10,
                  endWidth: 10)
            ], pointers: <GaugePointer>[
              NeedlePointer(value: lastVal, enableAnimation: true, animationDuration: 1000)
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                      child: Text('$lastVal dBm',
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
