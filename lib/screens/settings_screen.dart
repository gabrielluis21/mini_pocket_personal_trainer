import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/notifications/notification_settings_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/about_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/support_screen.dart';

class SettingsScreen extends StatelessWidget {
  UserModel model;

  SettingsScreen(this.model);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
        statusBarIconBrightness: Brightness.light));
    return Container(
      child: ListView(
        children: <Widget>[
          FlatButton(
            padding: EdgeInsets.all(6.0),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SupportScreen()));
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.headset_mic,
                  size: 60.0,
                ),
                Text(
                  "Suporte",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          FlatButton(
            padding: EdgeInsets.all(6.0),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotificationsSettingsScreen(model)));
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.info,
                  size: 60.0,
                ),
                Text(
                  "Notificações",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          FlatButton(
            padding: EdgeInsets.all(6.0),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutScreen()));
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.info,
                  size: 60.0,
                ),
                Text(
                  "Sobre",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
