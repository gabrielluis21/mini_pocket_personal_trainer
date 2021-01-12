import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/login_screen.dart';
import 'package:mini_pocket_personal_trainer/tiles/drawer_tiles.dart';
import 'package:mini_pocket_personal_trainer/screens/profile_screen.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 90, 90, 253),
            Colors.white,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        );
    final user = UserModel.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 21.5),
      child: Drawer(
        child: Stack(children: <Widget>[
            _buildDrawerBack(),
          ListView(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Bem vindo!",
                  style: TextStyle( fontSize: 32.0, fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic, color: Colors.white),
                ),
                UserAccountsDrawerHeader(
                   onDetailsPressed: () => Navigator.of(context).push(
                       MaterialPageRoute(builder: (context) => ProfileScreen(user) )
                   ),
                   accountName: Text(user.user['name']),
                   accountEmail: Text(user.user['email']),

                   currentAccountPicture: CircleAvatar(
                     maxRadius: 65.0,
                     backgroundImage: user.user["profilePhoto"] != null
                         ? NetworkImage(user.user["profilePhoto"])
                         : AssetImage("assets/images/person.png"),
                   ),
                 ),
              ],
            ),
            Divider(
              color: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Menu Principal",
                  style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                ),
              ],
            ),
            Divider(
              color: Colors.white,
            ),
            DrawerTile(Icons.home, " Home", pageController, 0),
            Divider(
              color: Colors.white,
            ),
            DrawerTile(Icons.list, "Exercícios", pageController, 1),
            Divider(
              color: Colors.white,
            ),
            DrawerTile(Icons.store, " Academias parceiras", pageController, 2),
            Divider(
              color: Colors.white,
            ),
            DrawerTile(Icons.settings, " Configurações", pageController, 3),
            Divider(
              color: Colors.white,
            ),
            SizedBox(
              height: 140.0,
            ),
            FlatButton(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.signOutAlt),
                    Text(
                      " Sair",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                UserModel.of(context).userSignOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ])),
    );
  }
}
