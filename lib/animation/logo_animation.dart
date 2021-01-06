import 'package:flutter/animation.dart';

class LogoAnimation{

  LogoAnimation(this.controller):

    logoSize = Tween<double>(begin:  0, end: maximumSize)
        .animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.0, 0.2, curve: Curves.easeIn)
        )
    ),

    dropPosition = Tween<double>(begin: 0, end: maximumRelativeDropY)
      .animate(CurvedAnimation(
         parent: controller,
        curve: Interval(0.2, 0.5, curve: Curves.easeIn)
      )
    ),

    holeSize = Tween<double>(begin: 0, end: maximumHoleSize)
      .animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    ),

    logoVisible = Tween<bool>(begin: true, end: false)
      .animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.5, 0.5),
      ),
    ),

    textOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.5, 0.7, curve: Curves.easeOut),
      ),
    );

  final AnimationController controller;

  final Animation<double> logoSize;
  final Animation<double> dropPosition;
  final Animation<double> holeSize;
  final Animation<bool> logoVisible;
  final Animation<double> textOpacity;

  static final double maximumSize = 250.0;
  static final double maximumRelativeDropY = 0.5;
  static final double maximumHoleSize = 10;
}