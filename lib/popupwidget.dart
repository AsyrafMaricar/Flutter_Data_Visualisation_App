import 'package:flutter/material.dart';
import 'globalvar.dart';

class PopupWidget extends StatefulWidget {

  @override
  createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {

  @override
  Widget build(BuildContext context) {
      return PopupMenuButton(
        onSelected: (choice) {
          if (choice == Constants.oneMinute) {


          } else if (choice == Constants.tenMinute) {

          } else if (choice == Constants.oneHour) {


          } else if (choice == Constants.oneDay) {

          }
        },
        itemBuilder: (BuildContext context) {
          return Constants.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      );
    }
  }
