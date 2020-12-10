import 'package:flutter/material.dart';
import 'package:flutter_app_2210/alertslistpage.dart';
import 'package:flutter_app_2210/popupwidget.dart';
import 'gaugespage.dart';
import 'chartspage.dart';
import 'globalvar.dart';

class HomePage extends StatefulWidget {
  final String pageTitle;

  const HomePage({Key key, this.pageTitle}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  final tabs = [
    GaugePage(),
    ChartsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        bottomOpacity: 0,
        backgroundColor: Colors.transparent,
        title: Text(
            widget.pageTitle,
            style: TextStyle(
            fontFamily: "Montserrat Medium",
            fontSize: 20,
            color: mainTextColor,
            fontWeight: FontWeight.normal)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           tabs[_currentIndex],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        unselectedItemColor: Colors.white,
        selectedFontSize: 15,
        selectedItemColor: accentColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items:[
          BottomNavigationBarItem(
            icon: Icon(Icons.av_timer),
            label:'Gauges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Charts',
          ),
        ], // items
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if(_currentIndex == 1) {
              chartsMounted = true;
            } else chartsMounted = false;
          });
        },
      ),
    );
  }
}

