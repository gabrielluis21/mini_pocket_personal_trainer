import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/login_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/updateprofile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel _model;

  ProfileScreen(this._model);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(bottom: 50.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Meu perfil"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 25.0,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdateProfileScreen()));
                }),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 9, bottom: 9),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                CircleAvatar(
                  maxRadius: 70.0,
                  backgroundImage: _model.user["profilePhoto"] != null
                      ? NetworkImage(_model.user["profilePhoto"])
                      : AssetImage("assets/images/person.png"),
                ),
              ]),
            ),
          Text(
            "${_model.user["name"]}",
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
          Text(
            "${_model.user["email"]}",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "${_model.user["address"]}",
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            "Meu histórico",
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.0,
          ),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("users")
                .doc(_model.firebaseUser.uid)
                .collection("myExercises")
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              int isDone = snapshot.data.docs
                  .where((e) => e.data()["isDone"] == true)
                  .toList()
                  .length;
              int notDone = snapshot.data.docs
                  .where((e) => e.data()["isDone"] == false)
                  .toList()
                  .length;
              return Center(
                child: Wrap(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        Icon(MdiIcons.target),
                        Text(
                          "Todos os exercícios: ${snapshot.data.docs.length.toString()}",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Wrap(
                      children: <Widget>[
                        Icon(Icons.done_all),
                        Text(
                          " Todos os exercícios feitos: ${isDone.toString()}",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Wrap(
                      children: <Widget>[
                        Icon(Icons.error),
                        Text(
                          " Todos os exercícios a fazer: ${notDone.toString()}",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )
        ]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async{
            await FirebaseFirestore.instance.collection('user')
            .doc(_model.firebaseUser.uid).delete();
            _model.firebaseUser.delete().then(
              (value) => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen())
              ));
           },
           icon: Icon(Icons.logout),
           label: Text("Desativar conta")),
      ),
    );
  }
}
