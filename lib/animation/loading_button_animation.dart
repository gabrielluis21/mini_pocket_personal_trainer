import 'package:flutter/material.dart';

class LoadingButtonAnimation extends StatelessWidget {
  final AnimationController controller;
  final String textoButton;
  final Color cor;
  final IconData icon;

  LoadingButtonAnimation({
    this.controller,
    this.textoButton,
    this.cor,
    this.icon}) :
        buttonSqueeze = Tween(
            begin: 320.0,
            end: 60.0
        ).animate(
            CurvedAnimation(
                parent: controller,
                curve: Interval(0.0, 0.150)
            )
        );

  final Animation<double> buttonSqueeze;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: InkWell(
        onTap: (){
          controller.forward().whenComplete(() => controller.reverse());
        },
        child: Container(
           width: buttonSqueeze.value,
           height: 60,
           alignment: Alignment.center,
           decoration: BoxDecoration(
             color: cor,
             borderRadius: BorderRadius.all(Radius.circular(30.0))
           ),
           child: _buildInside(context, textoButton),
        ),

      ),
    );
  }

  Widget _buildInside(BuildContext context, String text){
    if(buttonSqueeze.value > 75){
      return Row(
        children: [
          icon != null ?? Icon(this.icon),
          Text(
            "$text",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.3
            ),
          )
        ],
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 1.0,
      );
    }
  }
}
