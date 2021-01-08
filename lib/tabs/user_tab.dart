import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/profile_screen.dart';
import 'package:mini_pocket_personal_trainer/widgets/userExercise_list.dart';
import 'package:theme_manager/theme_manager.dart';

class UserTab extends StatelessWidget {
  final UserModel model;

  UserTab(this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfileScreen(model)));
          },
          child: Column(
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Align(
                alignment: FractionalOffset.center,
                child: CircleAvatar(
                  maxRadius: 65.0,
                  backgroundImage: model.user["profilePhoto"] != null
                      ? NetworkImage(model.user["profilePhoto"])
                      : AssetImage("assets/images/person.png"),
                ),
              ),),
              Text(
                "${!model.isLoggedIn() ? " " : model.user["name"]}",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Divider(
          color: ThemeManager.of(context).brightnessPreference == BrightnessPreference.dark ?
            Colors.white : Colors.black,
        ),
        Text("Meus Exercícios",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),),
        Divider(
          color: ThemeManager.of(context).brightnessPreference == BrightnessPreference.dark ?
          Colors.white : Colors.black,
        ),
        UserExerciseList(model),
      ],
    );
  }
}
