import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/user_exercises_data.dart';
import 'package:mini_pocket_personal_trainer/models/exercise_model.dart';

class CounterScreen extends StatefulWidget {
  final UserExercises exercises;

  CounterScreen(this.exercises);

  @override
  _CounterScreenState createState() => _CounterScreenState(exercises);
}

class _CounterScreenState extends State<CounterScreen>
    with TickerProviderStateMixin {
  final UserExercises exercise;

  _CounterScreenState(this.exercise);

  int _n = 0;

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  void add() {
    setState(() {
      _n++;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 50.0),
      child: Scaffold(
        backgroundColor: themeData.primaryColor,
        body: Container(
          padding: EdgeInsets.only(top: 150.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: FractionalOffset.center,
                  child: Text(
                    exercise.exerciseData.name,
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Align(
                  alignment: FractionalOffset.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          add();
                          if (_n == exercise.quantity) {
                            exercise.isDone = true;
                            ExercisesModel.of(context).updateExercise(exercise);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 25.0,
                      ),
                      Text('$_n', style: TextStyle(fontSize: 60.0)),
                      SizedBox(
                        width: 25.0,
                      ),
                      RaisedButton(
                        onPressed: minus,
                        child: Icon(Icons.remove, color: Colors.black),
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
