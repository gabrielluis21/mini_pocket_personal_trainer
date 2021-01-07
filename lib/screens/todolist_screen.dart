import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_pocket_personal_trainer/datas/user_exercises_data.dart';
import 'package:mini_pocket_personal_trainer/models/exercise_model.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/counter_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/exercise_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/timer_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  static List _toDoList;

  Future<Null> _refresh(List toDoList) async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      toDoList.sort((a, b) {
        if (a["isDone"] == true && b["isDone"] == false)
          return 1;
        else if (a["isDone"] == false && b["isDone"] == true)
          return -1;
        else
          return 0;
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                await _refresh(_toDoList);
              },
            ),
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(model.firebaseUser.uid)
                    .collection("myExercises")
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: FlareActor(
                          'assets/animations/WeightSpin.flr',
                          animation: 'Spin',
                        ),
                      ),
                    );
                  _toDoList = snapshot.data.docs;
                  return RefreshIndicator(
                    onRefresh: () async {
                      await _refresh(_toDoList);
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        UserExercises exercise;
                        exercise = UserExercises.fromDocument(
                            snapshot.data.docs[index]);

                        return GestureDetector(
                          onLongPress: () {
                            _bottomSheet(context, exercise);
                          },
                          child: Dismissible(
                            key: Key(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString()),
                            background: Container(
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment(-0.9, 0.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) {
                              setState(() {
                                ExercisesModel.of(context)
                                    .removeExercise(exercise);

                                final snack = SnackBar(
                                  content: Text(
                                      "Exercício: \"${exercise.exerciseData.name}\" removido"),
                                  action: SnackBarAction(
                                    label: "Desfazer",
                                    onPressed: () {
                                      setState(() {
                                        ExercisesModel.of(context)
                                            .insertExercise(exercise, index);
                                      });
                                    },
                                  ),
                                  duration: Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(snack);
                              });
                            },
                            child: CheckboxListTile(
                              title: Text(exercise.exerciseData.name),
                              value: exercise.isDone,
                              secondary: CircleAvatar(
                                  child: Icon(exercise.isDone
                                      ? Icons.check
                                      : Icons.error)),
                              onChanged: (c) {
                                setState(() {
                                  exercise.doneIn = DateTime.now();
                                  exercise.isDone = c;
                                  ExercisesModel.of(context)
                                      .updateExercise(exercise);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                });
          },
        ));
  }

  _bottomSheet(BuildContext context, UserExercises exercise) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              backgroundColor: Colors.white,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 50.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlatButton(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.description),
                                  Text("Detalhes"),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ExerciseScreen(exercise.exerciseData)));
                            }),
                        FlatButton(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.timer),
                                Text("Timer"),
                              ],
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TimerScreen(exercise)));
                          },
                        ),
                        FlatButton(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(MdiIcons.plusMinusBox),
                                  Text("Steps"),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      CounterScreen(exercise)));
                            }),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
