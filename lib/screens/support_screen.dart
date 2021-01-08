import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_pocket_personal_trainer/screens/how_to_use_screen.dart';
import 'package:theme_manager/theme_manager.dart';

class SupportScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final isDarkTheme = ThemeManager
        .of(context)
        .brightnessPreference == BrightnessPreference.dark ? true : false;

    return Scaffold(
      appBar: AppBar(
        title: Text("Suporte"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            padding: EdgeInsets.all(6.0),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HowToUseScreen())
            ),
            child: Container(
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.bookmark, size: 60.0,),
                  Text(" Guia de uso", style: TextStyle(fontSize: 16.0,
                      fontWeight: FontWeight.w900),),
                ],
              ),
            ),
          ),
          Divider(color: isDarkTheme ? Colors.white : Colors.black,),
          FlatButton(
            padding: EdgeInsets.all(6.0),
            onPressed: (){
              showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    titleTextStyle: TextStyle(fontSize: 24, color: Colors.red),
                    title: Text("Aviso!"),
                    contentTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    content: Center(
                      child: Text("Está funcionálidade ainda esta em desenvolvimento, fique atento na loja de aplicativos para futuras atualizações",
                      softWrap: true,),
                    ),
                  );
                }
              );
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.headset, size: 60.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 9),
                    child: Text("Conversar com um atendente", style: TextStyle(fontSize: 16.0,
                      fontWeight: FontWeight.w900,),),
                  )
                ],
              ),
            ),
          ),
          Divider(color: isDarkTheme ? Colors.white : Colors.black,),
        ],
      ),
    );
  }
}
