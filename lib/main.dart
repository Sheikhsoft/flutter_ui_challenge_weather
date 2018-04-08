import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/delayed_change.dart';
import 'package:weather/forecast_screen.dart';

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

class _MyHomePageState extends State<MyHomePage> {

  final Forecast forecast = new Forecast(
    items: [
      new ForecastTime(
        icon: new AssetImage('assets/ic_rain.png'),
        title: '11:30',
        subtitle: 'Light Rain',
      ),
      new ForecastTime(
        icon: new AssetImage('assets/ic_rain.png'),
        title: '12:30P',
        subtitle: 'Light Rain',
      ),
      new ForecastTime(
        icon: new AssetImage('assets/ic_cloudy.png'),
        title: '1:30P',
        subtitle: 'Cloudy',
      ),
      new ForecastTime(
        icon: new AssetImage('assets/ic_sunny.png'),
        title: '2:30P',
        subtitle: 'Sunny',
      ),
      new ForecastTime(
        icon: new AssetImage('assets/ic_sunny.png'),
        title: '3:30P',
        subtitle: 'Sunny',
      ),
    ],
  );

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: [
          new TelescopingMenuScreen(
            clearBackgroundImage: new AssetImage('assets/weather-bk.png'),
            blurredBackgroundImage: new AssetImage('assets/weather-bk_enlarged.png'),
            innerCircleRadius: 140.0,
            circleOffset: const Offset(40.0, 0.0),
            forecast: forecast,
          ),

          // App Bar
          new Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 32.0, bottom: 16.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Text(
                        'Tuesday, August 27',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )
                      ),
                      new Text(
                        'Sacramento',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                        )
                      ),
                    ],
                  ),
                ),
                new Expanded(child: new Container()),
                new Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: new DelayedChange(
                    delay: isDrawerOpen
                      ? const Duration(milliseconds: 200)
                      : const Duration(milliseconds: 0),
                    animatedWidgetBuilder: () {
                      final _isDrawerOpen = isDrawerOpen;
                      return (BuildContext context, Widget child) {
                        return new AnimatedOpacity(
                          opacity: _isDrawerOpen ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: child,
                        );
                      };
                    }(),
                    child: new IconButton(
                      icon: new Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 35.0,
                      ),
                      onPressed: () {
                        setState(() => isDrawerOpen = true);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),

          // Right Drawer
          isDrawerOpen
            ? new GestureDetector(
                onTap: () {
                  setState(() => isDrawerOpen = false);
                },
              )
            : new Container(),

          new DelayedChange(
            delay: isDrawerOpen
              ? const Duration(milliseconds: 0)
              : const Duration(milliseconds: 200),

            // This method runs after the animation delay is over, so we rebuild
            // the AnimatedPositioned Widget with the drawer at the new location.
            animatedWidgetBuilder: ()  {
              final isDrawerOpening = isDrawerOpen;

              return (BuildContext context, Widget child) {
                return new AnimatedPositioned(
                    top: 0.0,
                    bottom: 0.0,
                    right: isDrawerOpening? 0.0 : -125.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: child,
                );
              };
            }(),

            child: new WeekDrawer(),
          ),

        ],
      ),
    );
  }
}

class WeekDrawer extends StatelessWidget {
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
              ),
              new Expanded(
                child: new Text(
                  'Tuesday\nAugust 27',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              new Expanded(
                child: new Text(
                  'Tuesday\nAugust 27',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              new Expanded(
                child: new Text(
                  'Tuesday\nAugust 27',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              new Expanded(
                child: new Text(
                  'Tuesday\nAugust 27',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              new Expanded(
                child: new Text(
                  'Tuesday\nAugust 27',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              new Expanded(
                child: new Text(
                  'Tuesday\nAugust 27',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              new Expanded(
                child: new Text(
                  'Tuesday\nAugust 27',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

