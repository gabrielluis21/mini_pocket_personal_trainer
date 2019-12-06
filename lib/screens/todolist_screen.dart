import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/user_exercises_data.dart';
import 'package:mini_pocket_personal_trainer/models/exercise_model.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {

  Future<Null> _refresh(List toDoList) async{
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      toDoList.sort((a, b) {
        if (a["ok"] && !b["ok"]) return 1;
        else if (!a["ok"] && b["ok"]) return -1;
        else return 0;
      });
    });
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Exercícios"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return FutureBuilder<QuerySnapshot>(
              future: Firestore.instance.collection("users")
                  .document(model.firebaseUser.uid).collection("myExercises").getDocuments(),
              builder: (context, snapshot){
                if(!snapshot.hasData)
                  return Center(child: CircularProgressIndicator(),);

                return RefreshIndicator(
                  onRefresh: () async{
                    await _refresh(snapshot.data.documents);
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index){
                      UserExercises exercise = UserExercises.fromDocument(snapshot.data.documents[index]);

                      return Dismissible(
                        key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                        background: Container(
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment(-0.9, 0.0),
                            child: Icon(Icons.delete, color: Colors.white,),
                          ),
                        ),
                        direction: DismissDirection.startToEnd,
                        child: CheckboxListTile(
                            title: Text(exercise.exerciseData.name),
                            value: exercise.isDone,
                            secondary: CircleAvatar(
                                child: Icon(exercise.isDone ?
                                Icons.check : Icons.error)),
                            onChanged: (c){
                              setState(() {
                                exercise.doneIn = DateTime.now();
                                exercise.isDone = c;
                                ExercisesModel.of(context)
                                    .updateExercise(exercise);
                              });
                            }
                        ),
                        onDismissed: (direction){
                          setState(() {
                            ExercisesModel.of(context).removeExercise(exercise);

                            final snack = SnackBar(
                              content: Text("Exercício: \"${exercise.exerciseData.name }\" removido"),
                              action: SnackBarAction(
                                label: "Desfazer",
                                onPressed: (){
                                  setState(() {
                                    ExercisesModel.of(context)
                                        .insertExercise(exercise, index);
                                  });
                                },
                              ),
                              duration: Duration(seconds: 2),
                            );
                            Scaffold.of(context).removeCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(snack);
                          });
                        },
                      );
                    },
                  ),
                );
              }
          );

        },
      )
      );
    }
  }


