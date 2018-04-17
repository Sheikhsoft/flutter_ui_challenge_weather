import 'dart:ui' hide TextStyle;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/forecast/app_bar.dart';
import 'package:weather/forecast/forecast_screen.dart';
import 'package:weather/forecast/radial_list.dart';
import 'package:weather/forecast/week_drawer.dart';
import 'package:weather/forecast_list.dart';
import 'package:weather/general_widgets/sliding_drawer.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.dark,
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  SlidingRadialListController radialListController;
  OpenableController drawerController;
  String selectedDay = 'Tuesday, August 27';

  @override
  void initState() {
    super.initState();

    radialListController = new SlidingRadialListController(
        itemCount: 5,
        vsync: this
    );

    drawerController = new OpenableController(
        openDuration: const Duration(milliseconds: 300),
        vsync: this,
    )
    ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    radialListController.dispose();
    drawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: [
          new Forecast(
            clearBackgroundImage: new AssetImage('assets/weather-bk.png'),
            blurredBackgroundImage: new AssetImage('assets/weather-bk_enlarged.png'),
            innerCircleRadius: 140.0,
            circleOffset: const Offset(40.0, 0.0),
            menuController: radialListController,
            radialList: forecastRadialList,
          ),

          // App Bar
          new Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: new ForecastAppBar(
              drawerController: drawerController,
              selectedDay: selectedDay,
            ),
          ),

          // Right Drawer
          new SlidingDrawer(
            openableController: drawerController,
            drawer: new WeekDrawer(
              onDaySelected: (String title) {
                setState(() {
                  selectedDay = title.replaceAll('\n', ', ');
                  radialListController.close().then((nothing) => radialListController.open());
                  drawerController.close();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}