import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/user_exercises_data.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/todolist_screen.dart';
import 'package:mini_pocket_personal_trainer/tiles/user_exercise_tile.dart';

class UserTab extends StatelessWidget {

  final UserModel model;

  UserTab(this.model);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: CircleAvatar(
            radius: 50.0,
            backgroundImage: model.user["profilePhoto"] != null ?
              NetworkImage(model.user["profilePhoto"]) :
              AssetImage("images/person.png"),
             ),
        ),
        Flexible(
          flex: 1,
          child: Text("${!model.isLoggedIn() ? "": model.user["name"] }",
            style: TextStyle(fontSize: 30.0,
              fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 6,
          child: FutureBuilder(
            future: Firestore.instance.collection("users")
             .document(model.firebaseUser.uid).collection("myExercises").getDocuments(),
            builder: (context, snapshot){
            if(snapshot.hasData == false)
              return Center(child: Text("Sem exercícios para fazer!",
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
               ),);

            return GestureDetector(
               onTap: (){
                 Navigator.of(context).push(
                   MaterialPageRoute(
                     builder: (context) => ToDoListScreen()
                   )
                 );
                },
              child: ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  UserExercises exercise;
                  exercise = UserExercises.fromDocument(snapshot.data.documents[index]);
                  return UserExerciseTile(exercise);
                 }
              ),
            );
          },
          ),
        )
      ],
    );
  }
}
