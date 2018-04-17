import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:weather/general_widgets/sliding_drawer.dart';
import 'package:weather/general_widgets/spinner_text.dart';

class ForecastAppBar extends StatefulWidget {

  final String selectedDay;
  final OpenableController drawerController;

  ForecastAppBar({
    @required this.drawerController,
    this.selectedDay = '',
  });

  @override
  ForecastAppBarState createState() {
    return new ForecastAppBarState();
  }
}

class ForecastAppBarState extends State<ForecastAppBar> {

  bool aboutToOpenDrawer = false;

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: false,
      title: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          new SpinnerText(
            text: widget.selectedDay,
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
      actions: [
        new AnimatedOpacity(
          opacity: widget.drawerController.isClosed() && !aboutToOpenDrawer ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: new IconButton(
            icon: new Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 35.0,
            ),
            onPressed: () {
              setState(() => aboutToOpenDrawer = true);

              new Timer(
                const Duration(milliseconds: 300),
                () {
                  widget.drawerController.open();
                  setState(() => aboutToOpenDrawer = false);
                },
              );
            },
          ),
        )
      ],
    );
  }
}
