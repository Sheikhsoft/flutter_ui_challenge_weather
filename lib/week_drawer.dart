import 'dart:ui' hide TextStyle;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeekDrawer extends StatelessWidget {

  final week = [
    'Tuesday\nAugust 27',
    'Wednesday\nAugust 28',
    'Thursday\nAugust 29',
    'Friday\nAugust 30',
    'Saturday\nAugust 31',
    'Sunday\nSeptember 1',
    'Monday\nSeptember 2',
  ];

  final Function(String title) onDaySelected;

  WeekDrawer({
    this.onDaySelected,
  });

  List<Widget> _createDayButtons() {
    return week.map((String title) {
      return new Expanded(
        child: new GestureDetector(
          onTap: () {
            onDaySelected(title);
          },
          child: new Text(
            title,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new BackdropFilter(
      filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY:3.0),
      child: new Container(
        width: 125.0,
        height: double.infinity,
        color: const Color(0xAA234060),
        child: new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Column(
            children: [
              new Expanded(
                child: new Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 40.0,
                ),
              )]
              ..addAll(_createDayButtons()),
          ),
        ),
      ),
    );
  }
}