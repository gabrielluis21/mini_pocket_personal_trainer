import 'package:flutter/animation.dart';

class LogoAnimation{
  LogoAnimation(this._controller);

  Animation<double> get logoSize => Tween<double>(begin: 5.0, end: maximumSize)
      .animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.2, curve: Curves.easeIn)
      )
  );

  Animation<double> get position => Tween<double>(begin: 0, end: maximumRelativeElevY)
    .animate(CurvedAnimation(
       parent: _controller,
       curve: Interval(0.0, 0.2, curve: Curves.easeIn)
     )
  );

  final AnimationController _controller;

  static final double maximumSize = 250.0;
  static final double maximumRelativeElevY = 0.5;
}