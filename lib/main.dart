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
        ],
      ),
    );
  }
}

