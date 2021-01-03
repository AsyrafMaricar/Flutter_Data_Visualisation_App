import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_2210/globalvar.dart';
import 'package:flutter_app_2210/humiditytimepage.dart';
import 'package:flutter_app_2210/orientationswitcher.dart';
import 'package:flutter_app_2210/temptimepage.dart';

class ChartsPage extends StatefulWidget {
  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {

  List<Widget> containers = [
        OrientationSwitcher(
          children: [
            TempTimePage(),
          ],
        ),
        OrientationSwitcher(
          children: [
            HumidityTimePage(),
          ],
        ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Expanded(
        child: Scaffold(
          backgroundColor: subCardColor,
          resizeToAvoidBottomPadding: true,
          appBar: TabBar(
              tabs: <Widget>[
                Tab(
                  text: 'Temperature',
                ),
                Tab(
                  text: 'Humidity',
                ),
                
              ],
            ),
          body: TabBarView(
            children: containers,
            ),
          ),
        ),
    );
  }
}