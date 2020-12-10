import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_2210/globalvar.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AboutsPage extends StatelessWidget {
  final String payload;

  const AboutsPage({Key key, this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      color: scaffoldColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                height: size.height * 0.05,
                width: size.width,
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: accentColor,),
                      onPressed: () {
                        Navigator.pop(context);
                        },
                    ),
                    SizedBox(),
                  ],
                ),
              ),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: subCardColor,
                child: Container(
                  height: size.height * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Image(
                                image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/f/ff/Singapore_Polytechnic_logo.png')),
                          ),
                        color: subCardColor,
                        margin: EdgeInsets.all(10),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Center(
                              child: Text('This is a data visualisation application created for IE4001 Smart Facility Management at Singapore Polytechnic.',
                                style: TextStyle(fontFamily: "Montserrat Medium", fontSize: 16),
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.5,
                              ),
                            ),
                            Center(
                              child: Text('\nThis application is developed using the Flutter SDK and retrieves its data from a REST API connected to the database on AWS ',
                                style: TextStyle(fontFamily: "Montserrat Medium", fontSize: 16),
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
