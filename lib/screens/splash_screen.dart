import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/animation/logo_animation.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/home_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  Size size = Size.zero;
  AnimationController _controller;
  LogoAnimation _logo;

  @override
  void initState() {
    _controller = AnimationController(
       duration: const Duration(milliseconds: 3000),
       vsync: this);
    _logo = LogoAnimation(_controller);

    _controller.forward().whenComplete(() async{
      UserModel.of(context).autoLogin().then((value){
        if(value){
          _controller.reverse().then(
             (value) => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen())
             )
          );
        }else{
          _controller.reverse().then(
                  (value) => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen())
              )
          );
        }
      });
     }
    );
    
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      size = MediaQuery.of(context).size;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Positioned(
          bottom: _logo.position.value * size.height,
          left: size.width / 2 - _logo.logoSize.value / 2,
          child: Image.asset("assets/images/logo.png",
            height: _logo.logoSize.value,
             width: _logo.logoSize.value,
           ),
         ),
        Positioned(
          top: _logo.position.value * size.height,
          left: size.width / 2 - _logo.logoSize.value / 2,
          child: Text("Pocket Personal Trainer",
            style: TextStyle(fontSize: 22, color: Colors.black,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline
            ),
          ),
        ),
      ],
    );
  }
}
