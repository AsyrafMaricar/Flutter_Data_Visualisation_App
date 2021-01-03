import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_2210/charts/movinghumiditylinechart.dart';
import 'charts/statichumiditylinechart.dart';

class HumidityTimePage extends StatefulWidget {
  @override
  _HumidityTimePageState createState() => _HumidityTimePageState();
}

class _HumidityTimePageState extends State<HumidityTimePage> {

  List<Widget> containers = [
    StaticHumidityChart(chartDataFirst: 60),
    StaticHumidityChart(chartDataFirst: 360),
    StaticHumidityChart(chartDataFirst: 3600),
    StaticHumidityChart(chartDataFirst: 8640),
    MovingRealHumidityChart(),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 5,
      child: Expanded(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomPadding: true,
          appBar: TabBar(
              tabs: <Widget>[
                Tab(
                  text: '10M',
                ),
                Tab(
                  text: '1H',
                ),
                Tab(
                  text: '10H',
                ),
                Tab(
                  text: '24H',
                ),
                Tab(
                  text: 'Real',
                ),
              ],
            ),

          body: Container(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: containers,
                  ),
              ),
          ),
          ),
        );
  }
}