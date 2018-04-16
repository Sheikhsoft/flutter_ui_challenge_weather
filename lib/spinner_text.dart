import 'package:flutter/material.dart';

class SpinnerText extends StatefulWidget {

  final String text;

  SpinnerText({
    this.text,
  });

  @override
  _SpinnerTextState createState() => new _SpinnerTextState();
}

class _SpinnerTextState extends State<SpinnerText> with SingleTickerProviderStateMixin {

  String text1 = '';
  String text2 = '';
  AnimationController _spinTextAnimationController;
  Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();
    text1 = widget.text;

    _spinTextAnimationController = new AnimationController(
        duration: const Duration(milliseconds: 750),
        vsync: this
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            text1 = text2;
            text2 = '';
            _spinTextAnimationController.value = 0.0;
          });
        }
      });

    _spinAnimation = new CurvedAnimation(
      parent: _spinTextAnimationController,
      curve: Curves.elasticInOut,
    );
  }

  @override
  void didUpdateWidget(SpinnerText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      // Need to spin.
      text2 = widget.text;
      _spinTextAnimationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ClipRect(
      clipper: new RectClipper(),
      child: new Stack(
          children: [
            new FractionalTranslation(
              translation: new Offset(0.0, _spinAnimation.value),
              child: new Text(
                text1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            new FractionalTranslation(
              translation: new Offset(0.0, _spinAnimation.value - 1.0),
              child: new Text(
                text2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ]
      ),
    );
  }
}

class RectClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

}