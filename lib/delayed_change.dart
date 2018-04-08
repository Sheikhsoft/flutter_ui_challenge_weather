import 'dart:async';

import 'package:flutter/widgets.dart';

class DelayedChange extends StatefulWidget {

  final Function(BuildContext context, Widget child) animatedWidgetBuilder;
  final Duration delay;
  final Widget child;

  DelayedChange({
    this.animatedWidgetBuilder,
    this.delay,
    this.child,
  });

  @override
  _DelayedChangeState createState() => new _DelayedChangeState();
}

class _DelayedChangeState extends State<DelayedChange> {

  Function(BuildContext context, Widget child) animatedWidgetBuilder;
  Timer delayTimer;

  @override
  void initState() {
    super.initState();
    animatedWidgetBuilder = widget.animatedWidgetBuilder;
  }

  @override
  void didUpdateWidget(DelayedChange oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If a delay timer was already running, cancel it.
    delayTimer?.cancel();

    // Start a new delay timer that will rebuild the animated part of this
    // Widget after [delay] time has passed.
    delayTimer = new Timer(
      oldWidget.delay,
          () => setState(() {
        animatedWidgetBuilder = widget.animatedWidgetBuilder;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return animatedWidgetBuilder(context, widget.child);
  }
}