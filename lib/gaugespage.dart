import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_2210/charts/BattGauge.dart';
import 'package:flutter_app_2210/charts/OccupancyGauge.dart';
import 'package:flutter_app_2210/charts/LuxGauge.dart';
import 'package:flutter_app_2210/charts/RSSIGauge.dart';


import 'package:flutter_app_2210/orientationswitcher.dart';

class GaugePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

      return OrientationSwitcher(
        children: <Widget>[
          Container(height: (size.height - kToolbarHeight) * 0.4 ,child: RSSIGauge()),
          Container(height: (size.height - kToolbarHeight) * 0.4, child: BatteryGauge()),//LuxGauge()),
        ],
      );
  }
}
