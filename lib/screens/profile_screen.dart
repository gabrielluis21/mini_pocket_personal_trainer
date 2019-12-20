import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
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
        body: ListView(children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            CircleAvatar(
              maxRadius: 70.0,
              backgroundImage: _model.user["profilePhoto"] != null
                  ? NetworkImage(_model.user["profilePhoto"])
                  : AssetImage("assets/images/person.png"),
            ),
          ]),
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
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "${_model.user["address"]}",
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
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
            future: Firestore.instance
                .collection("users")
                .document(_model.firebaseUser.uid)
                .collection("myExercises")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              int isDone = snapshot.data.documents
                  .where((e) => e.data["isDone"] == true)
                  .toList()
                  .length;
              int notDone = snapshot.data.documents
                  .where((e) => e.data["isDone"] == false)
                  .toList()
                  .length;
              return Wrap(
                direction: Axis.vertical,
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      Icon(MdiIcons.target),
                      Text(
                        "Todos os exercícios: ${snapshot.data.documents.length.toString()}",
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
              );
            },
          )
        ]),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {}, label: Text("Desativar conta")),
      ),
    );
  }
}