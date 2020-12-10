import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app_2210/globalvar.dart';

class AlertsTable extends StatefulWidget {
  final String alertsUrl;
  final String pageTitle;

  const AlertsTable({Key key, this.alertsUrl, this.pageTitle}) : super(key: key);

  @override
  _AlertsTableState createState() => _AlertsTableState();
}

class _AlertsTableState extends State<AlertsTable> {

  List<SensirionData> chartData = [];
  Timer _loadTimer;
  bool loading = true;

  Future<String> getChartJsonFromDatabase() async {
    // Sending get(url) request using the http client to retrieve the response.
    var response = await http.get("http://meter.m1sensordata.com/sensirionPHP/getenv101.php?n=360");
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
    super.initState();
    loadSensorData();
    _loadTimer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      chartData.clear();
      loadSensorData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _loadTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        bottomOpacity: 0,
        title: Text(widget.pageTitle,
            style: TextStyle(
                fontFamily: "Montserrat Medium",
                fontSize: 20,
                color: mainTextColor,
                fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: accentColor
        ),
      ),
      backgroundColor: scaffoldColor,
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              height:(size.height - kToolbarHeight - size.height*0.05) * 0.1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "Devices",
                      style: TextStyle(
                          fontFamily: "Montserrat Medium",
                          fontSize: 16,
                          color: mainTextColor,
                          fontWeight: FontWeight.normal)
                  ),
                  Text(
                      "Temperature",
                      style: TextStyle(
                          fontFamily: "Montserrat Medium",
                          fontSize: 16,
                          color: mainTextColor,
                          fontWeight: FontWeight.normal)
                  ),
                  Text(
                      "Humidity",
                      style: TextStyle(
                          fontFamily: "Montserrat Medium",
                          fontSize: 16,
                          color: mainTextColor,
                          fontWeight: FontWeight.normal)
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: chartData.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: subCardColor,
                    child: Container(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        height: 75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                "${chartData[index].device}",
                                style: TextStyle(
                                    fontFamily: "Montserrat Medium",
                                    fontSize: 16,
                                    color: mainTextColor,
                                    fontWeight: FontWeight.normal)
                            ),
                            Text(
                                "${chartData[index].sen2} °C",
                                style: TextStyle(
                                    fontFamily: "Montserrat Medium",
                                    fontSize: 16,
                                    color: mainTextColor,
                                    fontWeight: FontWeight.normal)
                            ),
                            Text(
                                "${chartData[index].sen1} %",
                                style: TextStyle(
                                    fontFamily: "Montserrat Medium",
                                    fontSize: 16,
                                    color: mainTextColor,
                                    fontWeight: FontWeight.normal)
                            ),
                          ],
                        )
                    ),
                  );
                },),
            ),
          ],
        ),
      ),
    );
  }
}
