import 'package:flutter/material.dart';

class TelescopingOverlay extends StatelessWidget {

  final ImageProvider rawBackground;
  final ImageProvider frostedBackground;
  final double seeThruCircleRadius;
  final Offset telescopingCircleOffset;

  TelescopingOverlay({
    this.rawBackground,
    this.frostedBackground,
    this.seeThruCircleRadius,
    this.telescopingCircleOffset,
  });

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        // Blurry Foreground Backdrop
        new Image(
          image: frostedBackground,
          fit: BoxFit.cover,
        ),

        // Clear/crisp Background Backdrop
        new ClipOval(
          clipper: new CircleClipper(
            radius: seeThruCircleRadius,
            offset: telescopingCircleOffset,
          ),
          child: new Image(
            image: rawBackground,
            fit: BoxFit.cover,
          ),
        ),

        // Translucent white overlay with circles cut out.
        new CustomPaint(
          painter: new WhiteCircleCutoutPainter(
            offset: telescopingCircleOffset,
            circles: [
              new Circle(radius: seeThruCircleRadius, alpha: 0x10),
              new Circle(radius: seeThruCircleRadius + 15.0, alpha: 0x28),
              new Circle(radius: seeThruCircleRadius + 30.0, alpha: 0x38),
              new Circle(radius: seeThruCircleRadius + 75.0, alpha: 0x50),
            ],
          ),
          child: new Container(),
        ),
      ],
    );
  }
}


class CircleClipper extends CustomClipper<Rect> {

  final double radius;
  final Offset offset;

  CircleClipper({
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

class Circle {
  final double radius;
  final int alpha;

  Circle({
    this.radius,
    this.alpha = 0xFF,
  });
}