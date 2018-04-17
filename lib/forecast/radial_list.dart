import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:weather/general_widgets/radial_position.dart';

enum RadialListState {
  closed,
  slidingOpen,
  open,
  fadingOut,
}

class SlidingRadialMenu extends StatefulWidget {

  final double radius;
  final int menuLength;
  final SlidingRadialListController menuController;
  final Function(BuildContext, int index) menuItemBuilder;
  final double firstItemAngle;
  final double lastItemAngle;

  SlidingRadialMenu({
    @required this.radius,
    @required this.menuLength,
    @required this.menuController,
    @required this.menuItemBuilder,
    @required this.firstItemAngle,
    @required this.lastItemAngle,
  });

  @override
  _SlidingRadialMenuState createState() => new _SlidingRadialMenuState();
}

class _SlidingRadialMenuState extends State<SlidingRadialMenu> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    widget.menuController
      ..addListener(_onControllerChange)
      ..open();
  }

  _onControllerChange() {
    setState(() => {});
  }

  List<Widget> _createItems() {
    final List<Widget> menuItems = [];

    for (var index = 0; index < widget.menuLength; ++index) {
      menuItems.add(
          new Opacity(
            opacity: widget.menuController.getItemOpacity(index),
            child: new RadialPosition(
              radius: widget.radius,
              angle: widget.menuController.getItemAngle(index),
              child: widget.menuItemBuilder(context, index),
            ),
          )
      );
    }

    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
//        _createDebugCircle(),
      ]..addAll(_createItems()),
    );
  }
}

class SlidingRadialListController extends ChangeNotifier {
  final double firstItemAngle = -pi/3;
  final double lastItemAngle = pi/3;
  final double startSlidingAngle = 3 * pi / 4;

  final int itemCount;
  final List<Animation<double>> _slidePositions;
  final AnimationController _slideController;
  final AnimationController _fadeController;
  RadialListState state = RadialListState.closed;
  Completer onOpenedCompleter;
  Completer onClosedCompleter;

  SlidingRadialListController({
    this.itemCount,
    vsync,
  }) : _slideController = new AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync
  ),
        _fadeController = new AnimationController(
            duration: const Duration(milliseconds: 150),
            vsync: vsync
        ),
        _slidePositions = [] {
    _slideController
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = RadialListState.slidingOpen;
            notifyListeners();
            break;
          case AnimationStatus.completed:
            state = RadialListState.open;
            notifyListeners();
            onOpenedCompleter.complete();
            break;
          case AnimationStatus.reverse:
          case AnimationStatus.dismissed:
            break;
        }
      });

    _fadeController
      ..addListener(notifyListeners)
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = RadialListState.fadingOut;
            notifyListeners();
            break;
          case AnimationStatus.completed:
            state = RadialListState.closed;
            _slideController.value = 0.0;
            _fadeController.value = 0.0;
            notifyListeners();
            onClosedCompleter.complete();
            break;
          case AnimationStatus.reverse:
          case AnimationStatus.dismissed:
            break;
        }
      });

    final delayInterval = 0.1;
    final slideInterval = 0.5;
    final angleDeltaPerItem = (lastItemAngle - firstItemAngle) / (itemCount - 1);
    for (var i = 0; i < itemCount; ++i) {
      final start = delayInterval * i;
      final end = start + slideInterval;

      final endSlidePosition = firstItemAngle + (angleDeltaPerItem * i);
      _slidePositions.add(
          new Tween(
            begin: startSlidingAngle,
            end: endSlidePosition,
          ).animate(
              new CurvedAnimation(
                  parent: _slideController,
                  curve: new Interval(start, end, curve: Curves.easeInOut)
              )
          )
      );
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  getItemAngle(int index) {
    return _slidePositions[index].value;
  }

  getItemOpacity(int index) {
    switch (state) {
      case RadialListState.closed:
        return 0.0;
      case RadialListState.slidingOpen:
      case RadialListState.open:
        return 1.0;
      case RadialListState.fadingOut:
        return (1.0 - _fadeController.value);
    }
  }

  Future open() {
    if (state == RadialListState.closed) {
      _slideController.forward();
      onOpenedCompleter = new Completer();
      return onOpenedCompleter.future;
    }
    return null;
  }

  close() {
    if (state == RadialListState.open) {
      _fadeController.forward();
      onClosedCompleter = new Completer();
      return onClosedCompleter.future;
    }
  }
}

class RadialListItem extends StatelessWidget {

  final RadialListItemViewModel listItem;
  final bool isSelected;

  RadialListItem({
    this.listItem,
    this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final circleDecoration = isSelected
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
        children: [
          new Container(
            width: 60.0,
            height: 60.0,
            decoration: circleDecoration,
            child: new Padding (
              padding: const EdgeInsets.all(7.0),
              child: new Image(
                image: listItem.icon,
                color: isSelected ? const Color(0xFF6688CC) : Colors.white,
              ),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

  RadialListItemViewModel({
    this.icon,
    this.title,
    this.subtitle,
  });
}