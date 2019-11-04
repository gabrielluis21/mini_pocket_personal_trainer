import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suporte"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            padding: EdgeInsets.all(6.0),
            onPressed: (){},
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
          Divider(color: Colors.black,),
          FlatButton(
            padding: EdgeInsets.all(6.0),
            onPressed: (){},
            child: Container(
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.headset, size: 60.0,),
                  Text(" Chamar um atendente", style: TextStyle(fontSize: 16.0,
                      fontWeight: FontWeight.w900),),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
