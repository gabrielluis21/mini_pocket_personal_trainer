import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  final AnimationController controller;
  final String textoButton;
  final Color cor;

  StaggerAnimation({this.controller, this.textoButton, this.cor}) :
        buttonSqueeze = Tween(
            begin: 320.0,
            end: 60.0
        ).animate(
            CurvedAnimation(
                parent: controller,
                curve: Interval(0.0, 0.150)
            )
        ),
        buttonZoomOut = Tween(
          begin: 60.0,
          end: 1000.0,
        ).animate(
            CurvedAnimation(
              parent: controller,
              curve: Interval(0.5, 1, curve: Curves.bounceOut),
            )
        );

  final Animation<double> buttonSqueeze;
  final Animation<double> buttonZoomOut;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: InkWell(
          onTap: (){
            controller.forward();
          },
          child: Hero(
            tag: "fade",
            child: buttonZoomOut.value == 60 ?
            Container(
                width: buttonSqueeze.value,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: cor,
                    borderRadius: BorderRadius.all(Radius.circular(30.0))
                ),
                child: _buildInside(context, textoButton),
            ) :
            Container(
              width: buttonZoomOut.value,
              height: buttonZoomOut.value,
              decoration: BoxDecoration(
                  color: cor,
                  shape: buttonZoomOut.value < 500 ?
                  BoxShape.circle : BoxShape.rectangle
              ),
            ),
          )
      ),
    );
  }

  Widget _buildInside(BuildContext context, String text){
    if(buttonSqueeze.value > 75){
      return Text(
        "$text",
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.3
        ),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 1.0,
      );
    }
  }
}
