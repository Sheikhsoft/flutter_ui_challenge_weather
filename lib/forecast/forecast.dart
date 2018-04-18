import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:weather/forecast/background/background_with_rings.dart';
import 'package:weather/forecast/forecast_list.dart';

class Forecast extends StatelessWidget {

  List<Widget> _buildRadialMenuItems() {
    final double firstItemAngle = -pi/3;
    final double lastItemAngle = pi/3;
    final double angleDiff = (lastItemAngle - firstItemAngle) / (forecastRadialList.items.length - 1);

    double currAngle = firstItemAngle;

    return forecastRadialList.items.map((RadialListItemViewModel viewModel) {
      final listItem = _buildRadialMenuItem(viewModel, currAngle);
      currAngle += angleDiff;
      return listItem;
    }).toList();
  }

  Widget _buildRadialMenuItem(RadialListItemViewModel viewModel, double angle) {
    return new Transform(
      transform: new Matrix4.translationValues(
          40.0,
          334.0,
          0.0
      ),
      child: new RadialPosition(
        radius: 140.0 + 75.0,
        angle: angle,
        child: new RadialListItem(
          listItem: viewModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new BackgroundWithRings(
          rawBackground: new AssetImage('assets/weather-bk.png'),
          frostedBackground: new AssetImage('assets/weather-bk_enlarged.png'),
          seeThruCircleRadius: 140.0,
          seeThruCircleOffset: const Offset(40.0, 0.0),
        ),

        new Align(
          alignment: Alignment.centerLeft,
          child: new Padding(
            padding: const EdgeInsets.only(top: 150.0, left: 10.0),
            child: new Text(
              '68°',
              style: new TextStyle(
                color: Colors.white,
                fontSize: 80.0,
              ),
            ),
          ),
        ),

      ]
      ..addAll(_buildRadialMenuItems()),
    );
  }
}

class RadialPosition extends StatelessWidget {

  final double radius;
  final double angle;
  final Widget child;

  RadialPosition({
    this.radius,
    this.angle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final x = cos(angle) * radius;
    final y = sin(angle) * radius;

    return new Transform(
      transform: new Matrix4.translationValues(x, y, 0.0),
      child: child,
    );
  }
}


class RadialListItem extends StatelessWidget {

  final RadialListItemViewModel listItem;

  RadialListItem({
    this.listItem,
  });

  @override
  Widget build(BuildContext context) {
    final circleDecoration = listItem.isSelected
      ? new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        )
      : new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: new Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        );

    return new Transform(
      transform: new Matrix4.translationValues(-30.0, -30.0, 0.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            width: 60.0,
            height: 60.0,
            decoration: circleDecoration,
            child: new Padding(
              padding: const EdgeInsets.all(7.0),
              child: new Image(
                image: listItem.icon,
                color: listItem.isSelected ? const Color(0xFF6688CC) : Colors.white,
              ),
            )
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  listItem.title,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                new Text(
                  listItem.subtitle,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RadialListViewModel {
  final List<RadialListItemViewModel> items;

  RadialListViewModel({
    this.items,
  });
}

class RadialListItemViewModel {
  final ImageProvider icon;
  final String title;
  final String subtitle;
  final bool isSelected;

  RadialListItemViewModel({
    @required this.icon,
    @required this.title,
    @required this.subtitle,
    this.isSelected = false,
  });
}