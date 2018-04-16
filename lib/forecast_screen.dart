import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:weather/rain.dart';

class TelescopingMenuScreen extends StatelessWidget {

  final ImageProvider clearBackgroundImage;
  final ImageProvider blurredBackgroundImage;
  final double innerCircleRadius;
  final Offset circleOffset;
  final SlidingRadialMenuController menuController;
  final Forecast forecast;
  final int currentForecastIndex;

  TelescopingMenuScreen({
    @required this.clearBackgroundImage,
    @required this.blurredBackgroundImage,
    @required this.innerCircleRadius,
    @required this.menuController,
    this.circleOffset = const Offset(0.0, 0.0),
    this.forecast,
    this.currentForecastIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: [
        // Blurry Foreground Backdrop
        new Image(
          image: blurredBackgroundImage,
          fit: BoxFit.cover,
        ),

        // Clear/crisp Background Backdrop
        new ClipOval(
          clipper: new BackgroundCircleClipper(
            radius: innerCircleRadius,
            offset: circleOffset,
          ),
          child: new Image(
            image: clearBackgroundImage,
            fit: BoxFit.cover,
          ),
        ),

        new RainScreen(),

        // Translucent white overlay with circles cut out.
        new CustomPaint(
          painter: new WhiteCircleCutoutPainter(
            offset: circleOffset,
            circles: [
              new Circle(radius: innerCircleRadius, alpha: 0x10),
              new Circle(radius: innerCircleRadius + 15.0, alpha: 0x28),
              new Circle(radius: innerCircleRadius + 30.0, alpha: 0x38),
              new Circle(radius: innerCircleRadius + 75.0, alpha: 0x50),
            ],
          ),
          child: new Container(),
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
            menuLength: forecast.items.length,
            firstItemAngle: -pi/3,
            lastItemAngle: pi/3,
            menuController: menuController,
            menuItemBuilder: (BuildContext context, int index) {
              return new TimeForecast(
                time: forecast.items[index],
                isSelected: index == currentForecastIndex,
              );
            },
          )
        ),
      ],
    );
  }
}


class BackgroundCircleClipper extends CustomClipper<Rect> {

  final double radius;
  final Offset offset;

  BackgroundCircleClipper({
    this.radius,
    this.offset = const Offset(0.0, 0.0),
  });

  @override
  Rect getClip(Size size) {
    return new Rect.fromCircle(
      center: new Offset(0.0, size.height / 2) + offset,
      radius: radius,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

}

class Circle {
  final double radius;
  final int alpha;

  Circle({
    this.radius,
    this.alpha = 0xFF,
  });
}

class WhiteCircleCutoutPainter extends CustomPainter {

  final Color overlayColor = const Color(0xFFAA88AA);

  final List<Circle> circles;
  final Offset offset;
  final Paint whitePaint;
  final Paint borderPaint;

  WhiteCircleCutoutPainter({
    this.circles,
    this.offset = const Offset(0.0, 0.0),
  })
      : whitePaint = new Paint(),
        borderPaint = new Paint() {
    whitePaint.color = const Color(0x33FFFFFF);

    borderPaint
      ..color = const Color(0x10FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 1; i < circles.length; ++i) {
      _maskCircle(canvas, size, offset, circles[i-1].radius);

      whitePaint.color = overlayColor.withAlpha(circles[i-1].alpha);

      // Circle Fill
      canvas.drawCircle(
          new Offset(0.0, size.height / 2) + offset,
          circles[i].radius,
          whitePaint
      );

      // Circle Bevel
      canvas.drawCircle(
          new Offset(0.0, size.height / 2) + offset,
          circles[i-1].radius,
          borderPaint
      );
    }

    _maskCircle(canvas, size, offset, circles.last.radius);
    whitePaint.color = overlayColor.withAlpha(circles.last.alpha);
    canvas.drawRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height), whitePaint);
    canvas.drawCircle(new Offset(-1.0, size.height / 2 + 1) + offset, circles.last.radius, borderPaint);
  }

  _maskCircle(Canvas canvas, Size size, Offset offset, double radius) {
    Path clippedCircle = new Path();
    clippedCircle.fillType = PathFillType.evenOdd;
    clippedCircle.addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    clippedCircle.addOval(
        new Rect.fromCircle(
            center: new Offset(0.0, size.height / 2) + offset,
            radius: radius
        )
    );
    canvas.clipPath(clippedCircle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

class SlidingRadialMenu extends StatefulWidget {

  final double radius;
  final int menuLength;
  final SlidingRadialMenuController menuController;
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

class SlidingRadialMenuController extends ChangeNotifier {
  final double firstItemAngle = -pi/3;
  final double lastItemAngle = pi/3;
  final double startSlidingAngle = 3 * pi / 4;

  final int itemCount;
  final List<Animation<double>> _slidePositions;
  final AnimationController _slideController;
  final AnimationController _fadeController;
  RadialMenuState state = RadialMenuState.closed;
  Completer onOpenedCompleter;
  Completer onClosedCompleter;

  SlidingRadialMenuController({
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
            state = RadialMenuState.slidingOpen;
            notifyListeners();
            break;
          case AnimationStatus.completed:
            state = RadialMenuState.open;
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
            state = RadialMenuState.fadingOut;
            notifyListeners();
            break;
          case AnimationStatus.completed:
            state = RadialMenuState.closed;
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
      case RadialMenuState.closed:
        return 0.0;
      case RadialMenuState.slidingOpen:
      case RadialMenuState.open:
        return 1.0;
      case RadialMenuState.fadingOut:
        return (1.0 - _fadeController.value);
    }
  }

  Future open() {
    if (state == RadialMenuState.closed) {
      _slideController.forward();
      onOpenedCompleter = new Completer();
      return onOpenedCompleter.future;
    }
    return null;
  }

  close() {
    if (state == RadialMenuState.open) {
      _fadeController.forward();
      onClosedCompleter = new Completer();
      return onClosedCompleter.future;
    }
  }
}

enum RadialMenuState {
  closed,
  slidingOpen,
  open,
  fadingOut,
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


//class AnimatedRadialPosition extends ImplicitlyAnimatedWidget {
//
//  final double radius;
//  final double angle;
//  final Widget child;
//
//  AnimatedRadialPosition({
//    this.radius,
//    this.angle,
//    this.child,
//  }) : super(duration: const Duration(milliseconds: 250));
//
//  @override
//  _AnimatedRadialPositionState createState() => new _AnimatedRadialPositionState();
//}
//
//class _AnimatedRadialPositionState extends AnimatedWidgetBaseState<AnimatedRadialPosition> {
//
//  Tween<double> _angle = new Tween(begin: -pi);
//
//  @override
//  void forEachTween(TweenVisitor visitor) {
//    _angle = visitor(
//      _angle,
//      widget.angle,
//          (dynamic value) => new Tween(begin: value),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final x = cos(widget.angle) * widget.radius;
//    final y = sin(widget.angle) * widget.radius;
//
//    return new Transform(
//      transform: new Matrix4.translationValues(x, y, 0.0),
//      child: widget.child,
//    );
//  }
//}

class TimeForecast extends StatelessWidget {

  final ForecastTime time;
  final bool isSelected;

  TimeForecast({
    this.time,
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
                image: time.icon,
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
                  time.title,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                new Text(
                  time.subtitle,
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


class Forecast {
  final List<ForecastTime> items;

  Forecast({
    this.items,
  });
}

class ForecastTime {
  final ImageProvider icon;
  final String title;
  final String subtitle;

  ForecastTime({
    this.icon,
    this.title,
    this.subtitle,
  });
}