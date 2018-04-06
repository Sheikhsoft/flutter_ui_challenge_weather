import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: [
          // Background
          new Image(
            image: new AssetImage('assets/weather-bk_enlarged.png'),
            fit: BoxFit.cover,
          ),

          // Background
          new ClipOval(
            clipper: new BackgroundCircleClipper(
              radius: 160.0,
              offset: const Offset(40.0, 30.0),
            ),
            child: new Image(
              image: new AssetImage('assets/weather-bk.png'),
              fit: BoxFit.cover,
            ),
          ),

          // Translucent white overlay with circles cut out.
          new CustomPaint(
            painter: new WhiteCircleCutoutPainter(
              offset: const Offset(40.0, 30.0),
              circles: [
                new Circle(radius: 160.0, alpha: 0x10),
                new Circle(radius: 175.0, alpha: 0x18),
                new Circle(radius: 190.0, alpha: 0x24),
                new Circle(radius: 235.0, alpha: 0x30),
              ],
            ),
            child: new Container(),
          ),

          // City and Date
          new Positioned(
            child: new Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 32.0),
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
          ),

          // Drawer Arrow
          new Positioned(
            right: 0.0,
            child: new Padding(
              padding: const EdgeInsets.only(top: 32.0, right: 16.0),
              child: new Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 35.0,
              ),
            ),
          ),

          new Align(
            alignment: Alignment.centerLeft,
            child: new Padding(
              padding: const EdgeInsets.only(top: 150.0, left: 10.0),
              child: new Text(
                '68°',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 100.0,
                )
              ),
            ),
          ),

          new Transform(
            transform: new Matrix4.translationValues(45.0, 590.0, 0.0),
            child: new Transform(
              transform: new Matrix4.translationValues(-32.5, -32.5, 0.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Container(
                    width: 75.0,
                    height: 75.0,
                    decoration: new BoxDecoration(
                     shape: BoxShape.circle,
                     color: Colors.white,
                    ),
                    child: new Icon(
                      Icons.cloud_queue,
                      color: const Color(0xFF6688CC),
                      size: 50.0,
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(
                          '11:30',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                        new Text(
                          'Light Rain',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Drawer
//          new Positioned(
//            top: 0.0,
//            bottom: 0.0,
//            right: 0.0,
//            child: new Container(
//              width: 125.0,
//              height: double.infinity,
//              color: const Color(0xDD334466),
//              child: new Padding(
//                padding: const EdgeInsets.only(top: 16.0),
//                child: new Column(
//                  children: [
//                    new Expanded(
//                      child: new Icon(
//                        Icons.refresh,
//                        color: Colors.white,
//                        size: 40.0,
//                      ),
//                    ),
//                    new Expanded(
//                      child: new Text(
//                        'Tuesday\nAugust 27',
//                        style: new TextStyle(
//                          color: Colors.white,
//                          fontSize: 14.0,
//                        ),
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                    new Expanded(
//                      child: new Text(
//                        'Tuesday\nAugust 27',
//                        style: new TextStyle(
//                          color: Colors.white,
//                          fontSize: 14.0,
//                        ),
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                    new Expanded(
//                      child: new Text(
//                        'Tuesday\nAugust 27',
//                        style: new TextStyle(
//                          color: Colors.white,
//                          fontSize: 14.0,
//                        ),
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                    new Expanded(
//                      child: new Text(
//                        'Tuesday\nAugust 27',
//                        style: new TextStyle(
//                          color: Colors.white,
//                          fontSize: 14.0,
//                        ),
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                    new Expanded(
//                      child: new Text(
//                        'Tuesday\nAugust 27',
//                        style: new TextStyle(
//                          color: Colors.white,
//                          fontSize: 14.0,
//                        ),
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                    new Expanded(
//                      child: new Text(
//                        'Tuesday\nAugust 27',
//                        style: new TextStyle(
//                          color: Colors.white,
//                          fontSize: 14.0,
//                        ),
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                    new Expanded(
//                      child: new Text(
//                        'Tuesday\nAugust 27',
//                        style: new TextStyle(
//                          color: Colors.white,
//                          fontSize: 14.0,
//                        ),
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          ),

        ],
      ),
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
    const startAlpha = 0x10;
    const endAlpha = 0x40;
    final int alphaDelta = ((endAlpha - startAlpha) / circles.length).round();

    for (var i = 1; i < circles.length; ++i) {
      _maskCircle(canvas, size, offset, circles[i-1].radius);

      whitePaint.color = Colors.white.withAlpha(circles[i-1].alpha);

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
    whitePaint.color = Colors.white.withAlpha(circles.last.alpha);
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