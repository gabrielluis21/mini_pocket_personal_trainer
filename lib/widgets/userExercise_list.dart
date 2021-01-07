import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/user_exercises_data.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/todolist_screen.dart';
import 'package:mini_pocket_personal_trainer/tiles/user_exercise_tile.dart';

class UserExerciseList extends StatelessWidget {
  final UserModel model;

  UserExerciseList(this.model);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 6,
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(model.firebaseUser.uid)
            .collection("myExercises")
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Text(
                "Sem exercícios para fazer!",
                style:
                TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            );

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ToDoListScreen()));
            },
            child: ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  UserExercises exercise;
                  exercise = UserExercises.fromDocument(
                      snapshot.data.documents[index]);
                  return UserExerciseTile(exercise);
                }),
          );
        },
      ),
    );
  }
}
