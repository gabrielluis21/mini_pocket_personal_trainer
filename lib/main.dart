import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/models/exercise_model.dart';
import 'package:mini_pocket_personal_trainer/screens/home_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/user_model.dart';

const String appId = "ca-app-pub-8831023011848191~6860707039";

void main() async {
  runApp(MyApp());
  await FirebaseAdMob.instance.initialize(appId: appId);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return MaterialApp(
                title: 'Pocket Personal Trainer',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 90, 90, 253),
                ),
                debugShowCheckedModeBanner: false,
                home: Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              );

            if (model.firebaseUser != null) {
              return ScopedModel<ExercisesModel>(
                model: ExercisesModel(model),
                child: MaterialApp(
                  title: 'Pocket Personal Trainer',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    primaryColor: Color.fromARGB(255, 90, 90, 253),
                  ),
                  debugShowCheckedModeBanner: false,
                  home: HomeScreen(),
                ),
              );
            }

            return ScopedModel<ExercisesModel>(
              model: ExercisesModel(model),
              child: MaterialApp(
                title: 'Pocket Personal Trainer',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 90, 90, 253),
                ),
                debugShowCheckedModeBanner: false,
                home: LoginScreen(),
              ),
            );
          },
        ));
  }
}
