import 'package:flutter/material.dart';
import 'package:flutter_app_2210/globalvar.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Env1Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: subCardColor,
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        elevation: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesome.home,
              size: 100,
              color: Colors.white70,
            ),
            Text(
                'Sensor 1',
                style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 16,
                  color: mainTextColor,
                  fontWeight: FontWeight.normal)
            )
          ],
        ),
      ),
    );
  }
}

class Env2Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: subCardColor,
      shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      elevation: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            FlutterIcons.toilet_mco,
            color: Colors.pink[600],
            size: 100,
          ),
          Text(
              'Sensor 2',
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 16,
                  color: mainTextColor,
                  fontWeight: FontWeight.normal)
          )
        ],
      ),
    );
  }
}

class Env3Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: subCardColor,
      shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      elevation: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Entypo.lab_flask,
            color: Colors.blue[700],
            size: 100,
          ),
          Text(
              'Sensor 3',
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 16,
                  color: mainTextColor,
                  fontWeight: FontWeight.normal)
          )
        ],
      ),
    );
  }
}

class Env4Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: subCardColor,
      shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      elevation: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.kitchen,
            color: Colors.yellow[700],
            size: 100,
          ),
          Text(
              'Sensor 4',
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 16,
                  color: mainTextColor,
                  fontWeight: FontWeight.normal)
          )
        ],
      ),
    );
  }
}

class Env5Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: subCardColor,
      shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            FlutterIcons.warehouse_mco,
            color: Colors.orange[700],
            size: 100,
          ),
          Text(
              'Sensor 5',
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 16,
                  color: mainTextColor,
                  fontWeight: FontWeight.normal)
          )
        ],
      ),
    );
  }
}

class Env6Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: subCardColor,
      shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            MaterialCommunityIcons.office_building,
            color: Colors.red[700],
            size: 100,
          ),
          Text(
              'Sensor 6',
              style: TextStyle(
                  fontFamily: "Montserrat Medium",
                  fontSize: 16,
                  color: mainTextColor,
                  fontWeight: FontWeight.normal)
          )
        ],
      ),
    );
  }
}