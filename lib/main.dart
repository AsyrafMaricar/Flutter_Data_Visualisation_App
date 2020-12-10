import 'package:flutter/material.dart';
import 'package:flutter_app_2210/maindashboardwithsidebar.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        /*canvasColor:Color(0xff264653),
        primaryColor: Color(0xff264653),
        scaffoldBackgroundColor: Color(0x66264653),*/
      ),
      home: MenuDashboardPage(),
    );
  }
}


