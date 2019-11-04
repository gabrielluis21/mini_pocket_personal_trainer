import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/user_exercises_data.dart';

class UserExerciseTile extends StatelessWidget {

  final UserExercises userExercises;

  UserExerciseTile(this.userExercises);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: userExercises.isDone ? Colors.green : Colors.red,
      child: Row(
        children: <Widget>[
          /*Flexible(
             flex: 1,
             child: Image.network(
               userExercise.exerciseData.images[0],
               fit: BoxFit.cover, height: 250.0,),
           ),*/
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                   "${userExercises.isDone ? "${userExercises.dateMarked.day}/"
                       "${userExercises.dateMarked.month}/"
                       "${userExercises.dateMarked.year} Feito em:"
                       " ${userExercises.doneIn.day}/${userExercises.doneIn.month}/${userExercises.doneIn.year}"
                       " as ${userExercises.doneIn.hour}:${userExercises.doneIn.minute}":
                   "${userExercises.dateMarked.day}/"
                       "${userExercises.dateMarked.month}/"
                       "${userExercises.dateMarked.year}"}",
                  style: TextStyle(fontSize: 12.0),),
                  Text("${userExercises.quantity.toString()}x "
                      "${userExercises.exerciseData.name}  "
                    , style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
