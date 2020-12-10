import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_2210/charts/movingtemplinechart.dart';
import 'package:flutter_app_2210/charts/statictemplinechart.dart';
import 'package:flutter_app_2210/globalvar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TempTimePage extends StatefulWidget {

  @override
  _TempTimePageState createState() => _TempTimePageState();
}

class _TempTimePageState extends State<TempTimePage> {

  List<Widget> containers = [
    //StaticTempChart(chartDataFirst: 6),
    StaticTempChart(chartDataFirst: 60),
    StaticTempChart(chartDataFirst: 360),
    StaticTempChart(chartDataFirst: 3600),
    StaticTempChart(chartDataFirst: 8640),
    MovingRealTempChart(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Expanded(
        child: Scaffold(
          backgroundColor: subCardColor,
          resizeToAvoidBottomPadding: false,
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
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: containers,
            ),
          ),
        ),
    );
  }
}


