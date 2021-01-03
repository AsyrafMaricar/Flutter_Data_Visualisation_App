import 'package:flutter/material.dart';
import 'package:flutter_app_2210/maindashboardpage.dart';

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
      ),
      home: MenuDashboardPage(),
    );
  }
}


