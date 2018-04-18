import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather/generic_widgets/radial_position.dart';

class RadialList extends StatelessWidget {

  final RadialListViewModel radialList;

  RadialList({
    this.radialList,
  });

  List<Widget> _radialListItems() {
    final double firstItemAngle = -pi/3;
    final double lastItemAngle = pi/3;
    final double angleDiffPerItem = (lastItemAngle - firstItemAngle) / (radialList.items.length - 1);

    double currAngle = firstItemAngle;

    return radialList.items.map((RadialListItemViewModel viewModel) {
      final listItem = _radialListItem(viewModel, currAngle);
      currAngle += angleDiffPerItem;
      return listItem;
    }).toList();
  }

  Widget _radialListItem(RadialListItemViewModel viewModel, double angle) {
    return new Transform(
      transform: new Matrix4.translationValues(
        40.0,
        334.0,
        0.0,
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
      children: _radialListItems(),
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
        children: <Widget>[
          new Container(
            width: 60.0,
            height: 60.0,
            decoration: circleDecoration,
            child: new Padding(
              padding: const EdgeInsets.all(7.0),
              child: new Image(
                image: listItem.icon,
                color: listItem.isSelected ? const Color(0xFF6688CC) : Colors.white
              ),
            ),
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
    this.items = const [],
  });
}

class RadialListItemViewModel {
  final ImageProvider icon;
  final String title;
  final String subtitle;
  final bool isSelected;

  RadialListItemViewModel({
    this.icon,
    this.title = '',
    this.subtitle = '',
    this.isSelected = false,
  });
}