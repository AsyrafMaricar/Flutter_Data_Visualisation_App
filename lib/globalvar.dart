import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var url;
var singleUrl;

var cardColors = Color(0xff616e7c);
var chartColors = Color(0xff9e579d);
var scaffoldColor = Colors.black;
var mainTextColor = Color(0xfff5f7fa);
var subTextColor = Color(0xff9aa5b1);
var accentColor = Color(0xffd7be69);
var subCardColor = Color.fromARGB(255, 25, 25, 25);

int chartDataStart;

bool chartsMounted = false;


class Constants{
  static const String oneMinute = '1 Minute';
  static const String tenMinute = '10 Minutes';
  static const String oneHour = '1 Hour';
  static const String oneDay = '1 Day';

  static const List<String> choices = <String>[
    oneMinute,
    tenMinute,
    oneHour,
    oneDay,
  ];
}

class SensirionData {
  String date, device;
  dynamic sen1, sen2, sen3, sen4, sen5, sen6;
  var now = DateFormat.Hms().format(DateTime.now());

  SensirionData({this.date, this.sen1, this.sen2, this.sen3, this.sen4, this.sen5, this.sen6, this.device});

  factory SensirionData.fromJson(Map<String, dynamic> json) {
    return SensirionData(
      device: json["Device"].toString(),
      date: DateFormat.Hms().format((DateTime.parse(json['Date']))).toString(),
      sen1: json['Sen1'],
      sen2: json['Sen2'],
      sen3: json['Sen3'],
      sen4: json['Sen4'],
      sen5: json['Sen5'],
      sen6: json['Sen6'],
    );
  }
}

