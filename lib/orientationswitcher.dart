import 'package:flutter/material.dart';

class OrientationSwitcher extends StatelessWidget {
  final List<Widget> children;

  const OrientationSwitcher({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait
        ? Column(children: children)
        : Row(children: children);
  }
}