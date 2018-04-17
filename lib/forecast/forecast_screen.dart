import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:weather/forecast/background/rain.dart';
import 'package:weather/forecast/background/telescoping_overlay.dart';
import 'package:weather/forecast/radial_list.dart';

class Forecast extends StatelessWidget {

  final ImageProvider clearBackgroundImage;
  final ImageProvider blurredBackgroundImage;
  final double innerCircleRadius;
  final Offset circleOffset;
  final SlidingRadialListController menuController;
  final RadialListViewModel radialList;
  final int currentForecastIndex;

  Forecast({
    @required this.clearBackgroundImage,
    @required this.blurredBackgroundImage,
    @required this.innerCircleRadius,
    @required this.menuController,
    this.circleOffset = const Offset(0.0, 0.0),
    this.radialList,
    this.currentForecastIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: [
        new TelescopingOverlay(
          frostedBackground: blurredBackgroundImage,
          rawBackground: clearBackgroundImage,
          seeThruCircleRadius: innerCircleRadius,
          telescopingCircleOffset: circleOffset,
        ),

        // Center of circle content.
        new Align(
          alignment: Alignment.centerLeft,
          child: new Padding(
            padding: const EdgeInsets.only(top: 150.0, left: 10.0),
            child: new Text(
                '68°',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 80.0,
                )
            ),
          ),
        ),

        new Transform(
          transform: new Matrix4.translationValues(
            circleOffset.dx,
            334.0 + circleOffset.dy,
            0.0
          ),
          child: new SlidingRadialMenu(
            radius: innerCircleRadius + 75.0,
            menuLength: radialList.items.length,
            firstItemAngle: -pi/3,
            lastItemAngle: pi/3,
            menuController: menuController,
            menuItemBuilder: (BuildContext context, int index) {
              return new RadialListItem(
                listItem: radialList.items[index],
                isSelected: index == currentForecastIndex,
              );
            },
          )
        ),

        new RainScreen(),
      ],
    );
  }
}




