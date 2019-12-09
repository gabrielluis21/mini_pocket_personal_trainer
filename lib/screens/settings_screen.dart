import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/screens/about_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/support_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/updateprofile_screen.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
           FlatButton(
             padding: EdgeInsets.all(6.0),
             onPressed: (){
               Navigator.of(context).push(
                 MaterialPageRoute(builder: (context)=> UpdateProfileScreen() )
               );
             },
              child: Row(
                  children: <Widget>[
                    Icon(Icons.person_pin, size: 60.0,),
                    Text("Alterar Perfil",
                      style: TextStyle(fontSize: 16.0,
                          fontWeight: FontWeight.w900),),
                  ],
              ),
            ),
          FlatButton(
            padding: EdgeInsets.all(6.0),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SupportScreen())
              );
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.headset_mic, size: 60.0,),
                Text("Suporte",
                 style: TextStyle(fontSize: 16.0,
                    fontWeight: FontWeight.w900),),
              ],
            ),
          ),
          FlatButton(
            padding: EdgeInsets.all(6.0),
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> AboutScreen() )
              );
            },
            child:  Row(
              children: <Widget>[
               Icon(Icons.info, size: 60.0,),
               Text("Sobre",
                 style: TextStyle(fontSize: 16.0,
                 fontWeight: FontWeight.w900),),
               ],
            ),
          ),
        ],
      ),
    );
  }
}
