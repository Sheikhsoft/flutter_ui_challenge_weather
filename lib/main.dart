import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/forecast/app_bar.dart';
import 'package:weather/forecast/background/background_with_rings.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Weather',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final week = [
    'Tuesday\nAugust 27',
    'Wednesday\nAugust 28',
    'Thursday\nAugust 29',
    'Friday\nAugust 30',
    'Saturday\nAugust 31',
    'Sunday\nAugust 1',
    'Monday\nAugust 2',
  ];

  List<Widget> _buildDayButtons() {
    return week.map((String title) {
      return new Expanded(
        child: new GestureDetector(
          onTap: () {
            // TODO:
          },
          child: new Text(
            title,
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new BackgroundWithRings(
            rawBackground: new AssetImage('assets/weather-bk.png'),
            frostedBackground: new AssetImage('assets/weather-bk_enlarged.png'),
            seeThruCircleRadius: 140.0,
            seeThruCircleOffset: const Offset(40.0, 0.0),
          ),

          // App Bar
          new Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: new ForecastAppBar(),
          ),

          // Right Drawer
          new ClipRect(
            clipper: new RectClipper(),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: new Container(
                width: 125.0,
                height: double.infinity,
                color: const Color(0xAA234060),
                child: new Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: new Column(
                    children: <Widget>[
                      new Expanded(
                        child: new Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ),
                    ]
                    ..addAll(_buildDayButtons()),
                  )
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RectClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

}