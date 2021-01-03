import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_2210/aboutspage.dart';
import 'package:flutter_app_2210/alertslistpage.dart';
import 'package:flutter_app_2210/mainnavigatingpage.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dashboardcards.dart';
import 'globalvar.dart';

class MenuDashboardPage extends StatefulWidget {
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage> with SingleTickerProviderStateMixin {

  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 250);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Stack(
          children: <Widget>[
            menu(context),
            dashboard(context),
          ],
        ),
      ),
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Dashboard", style: TextStyle(fontFamily: "Montserrat Medium", color: accentColor, fontSize: 22)),
                SizedBox(height: 10),
                InkWell(onTap: () {
                  Navigator.push(context, CupertinoPageRoute(
                    builder: (context) => AlertsTable(pageTitle: 'Over-temperature Devices',),
                  ));
                } ,child: Text("Temp Alerts", style: TextStyle(fontFamily: "Montserrat Medium", color: accentColor, fontSize: 22))),
                SizedBox(height: 10),
                Text("--", style: TextStyle(fontFamily: "Montserrat Medium", color: accentColor, fontSize: 22)),
                SizedBox(height: 10),
                Text("--", style: TextStyle(fontFamily: "Montserrat Medium", color: accentColor, fontSize: 22)),
                SizedBox(height: 10),
                Text("--", style: TextStyle(fontFamily: "Montserrat Medium", color: accentColor, fontSize: 22)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.4 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: () {
            if (isCollapsed == false) {
              setState(() {
                if (isCollapsed)
                  _controller.forward();
                else
                  _controller.reverse();
                isCollapsed = !isCollapsed;
              });
            }
          },
          child: Material(
            animationDuration: duration,
            //borderRadius: BorderRadius.all(Radius.circular(40)),
            elevation: 8,
            color: scaffoldColor,
            child: Stack(
              children: <Widget>[
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: screenHeight * 0.05,
                          width: screenWidth,
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(icon: Icon(Octicons.three_bars), color: accentColor,
                                onPressed: () {
                                  setState(() {
                                    if (isCollapsed)
                                      _controller.forward();
                                    else
                                      _controller.reverse();
                                    isCollapsed = !isCollapsed;
                                  });
                                }
                              ),
                              Text('Sensors Data',
                                style: TextStyle(
                                    letterSpacing: 1,
                                    fontFamily: "Montserrat Medium",
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(icon: Icon(Octicons.info, color: accentColor),
                                onPressed: () {
                                  Navigator.push(context, CupertinoPageRoute(
                                    builder: (context) => AboutsPage(),
                                ));
                                }
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.75,
                          child: Center(
                            child: GridView.count(
                              shrinkWrap: true,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              primary: false,
                              crossAxisCount: 2,
                              children: <Widget>[
                                // InkWell widget allows for tap and routing functions
                                // on the card objects
                                InkWell(
                                  child: Env1Card(),
                                  onTap: () {
                                    url = "https://meter.m1sensordata.com/sensirionPHP/getenv15.php?n=360";
                                    singleUrl = "https://meter.m1sensordata.com/sensirionPHP/getenv15.php?n=0";
                                    Navigator.push(context, CupertinoPageRoute(
                                        builder: (context) => HomePage(pageTitle: 'Sensor 1',)),
                                    );
                                  },
                                ),

                                InkWell(
                                  child: Env2Card(),
                                  onTap: () {
                                    url = "https://meter.m1sensordata.com/sensirionPHP/getenv16.php?n=360";
                                    singleUrl = "https://meter.m1sensordata.com/sensirionPHP/getenv16.php?n=0";
                                    Navigator.push(context, CupertinoPageRoute(
                                        builder: (context) => HomePage(pageTitle: 'Sensor 2',)),
                                    );
                                  },
                                ),

                                InkWell(
                                  child: Env3Card(),
                                  onTap: () {
                                    url = "https://meter.m1sensordata.com/sensirionPHP/getenv17.php?n=360";
                                    singleUrl = "https://meter.m1sensordata.com/sensirionPHP/getenv17.php?n=0";
                                    Navigator.push(context, CupertinoPageRoute(
                                        builder: (context) => HomePage(pageTitle: 'Sensor 3',)),
                                    );
                                  },
                                ),

                                InkWell(
                                  child: Env4Card(),
                                  onTap: () {
                                    url = "https://meter.m1sensordata.com/sensirionPHP/getenv18.php?n=360";
                                    singleUrl = "https://meter.m1sensordata.com/sensirionPHP/getenv18.php?n=0";
                                    Navigator.push(context, CupertinoPageRoute(
                                        builder: (context) => HomePage(pageTitle: 'Sensor 4',)),
                                    );
                                  },
                                ),

                                InkWell(
                                  child: Env5Card(),
                                  onTap: () {
                                    url = "https://meter.m1sensordata.com/sensirionPHP/getenv18.php?n=360";
                                    singleUrl = "https://meter.m1sensordata.com/sensirionPHP/getenv18.php?n=0";
                                    Navigator.push(context, CupertinoPageRoute(
                                        builder: (context) => HomePage(pageTitle: 'Sensor 5',)),
                                    );
                                  },
                                ),

                                InkWell(
                                  child: Env6Card(),
                                  onTap: () {
                                    url = "https://meter.m1sensordata.com/sensirionPHP/getenv18.php?n=360";
                                    singleUrl = "https://meter.m1sensordata.com/sensirionPHP/getenv18.php?n=0";
                                    Navigator.push(context, CupertinoPageRoute(
                                        builder: (context) => HomePage(pageTitle: 'Sensor 6',)),
                                    );
                                  },
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}