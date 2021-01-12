import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/animation/logo_animation.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/painter/custom_hole_painter.dart';
import 'package:mini_pocket_personal_trainer/screens/home_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/how_to_use_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/login_screen.dart';


class SplashScreen extends StatefulWidget {
  final isFirstLaunch;

  SplashScreen(this.isFirstLaunch);

  @override
  _SplashScreenState createState() => _SplashScreenState(isFirstLaunch);
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final isFirstLaunch;
  _SplashScreenState(this.isFirstLaunch);

  AnimationController _controller;
  LogoAnimation _logo;

  void hasAutoLogged(){
    UserModel.of(context).autoLogin() ?
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context)=> HomeScreen()))
      :
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context)=> LoginScreen()));
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
       duration: const Duration(milliseconds: 3000),
       vsync: this);
    _logo = LogoAnimation(_controller);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isFirstLaunch != 0 ? hasAutoLogged() : Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HowToUseScreen())
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return  Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: CustomPaint(
                  painter: HolePainter(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      holeSize: _logo.holeSize.value * MediaQuery.of(context).size.width
                  ),
                ),
              ),
              Positioned(
                top: _logo.dropPosition.value * MediaQuery.of(context).size.height,
                left: MediaQuery.of(context).size.width / 2 - _logo.logoSize.value / 2,
                child: Visibility(
                  child: SizedBox(
                    height: _logo.logoSize.value,
                    width: _logo.logoSize.value,
                    child: CircleAvatar(
                      maxRadius: _logo.logoSize.value,
                      backgroundImage: AssetImage("assets/images/logo.png",),
                    ),
                  ),
                  visible: _logo.logoVisible.value,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: _logo.textOpacity.value,
                    child: Text("Pocket Personal Trainer",
                      style: TextStyle(fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ),

              ),
            ],
          );
      },
    );
  }
}