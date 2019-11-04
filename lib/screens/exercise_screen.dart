import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/exercise_data.dart';
import 'package:mini_pocket_personal_trainer/datas/user_exercises_data.dart';
import 'package:mini_pocket_personal_trainer/models/exercise_model.dart';
import 'package:mini_pocket_personal_trainer/screens/todolist_screen.dart';

import 'photo_screen.dart';

class ExerciseScreen extends StatefulWidget {

  final ExerciseData _exercise;

  ExerciseScreen(this._exercise);

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState(_exercise);
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final ExerciseData _exercise;
  DateTime date;

  _ExerciseScreenState(this._exercise);

  final userExercise = UserExercises();
  final quant = TextEditingController();
  final day = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(_exercise.name),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
           aspectRatio: 0.8,
            child: Carousel(
              images: _exercise.images.map((url){
               return NetworkImage(url);
               }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: color,
              autoplay: false,
              onImageTap: (image){
                Navigator.of(context).push(
                MaterialPageRoute(
                 builder: (context) =>
                     PhotoScreen(_exercise.name,_exercise.images[image])
                )
              );
            },
          ),
          ),
          Text(_exercise.name,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),),
          SizedBox(height: 10.0,),
          TextField(
            decoration: InputDecoration(
                labelText: "Quantidade: "
            ),
            controller: quant,
            keyboardType: TextInputType.number,
          ),          
          SizedBox(height: 10.0,),
          Text(_exercise.description ?? "",
          style: TextStyle(fontSize: 14.0),),
          SizedBox(height: 10.0,),
          FlatButton(
            onPressed: () async{
              date = await showDatePicker(context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.parse("2000-01-01 00:00:00.00000"),
                  lastDate: DateTime(DateTime.now().year, DateTime.december, 31));
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              height: 50.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(" Escolher o dia ",
                    style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                    textAlign: TextAlign.center,
                  ),
                  Icon(Icons.calendar_today,),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          FlatButton(
            child: Container(
              padding: EdgeInsets.all(8.0),
              height: 50.0,
              color: Theme.of(context).primaryColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white,),
                  Text(" Adicionar aos meus Exercício ",
                    style: TextStyle(color: Colors.white,
                        fontSize: 16.0, fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            onPressed: (){
              setState(() {
                userExercise.categoryExercise = _exercise.category;
                userExercise.exerciseId = _exercise.id;
                userExercise.isDone = false;
                userExercise.quantity = int.parse(quant.text);
                userExercise.dateMarked = date;
                userExercise.exerciseData = _exercise;

                print(userExercise.toMap());

                ExercisesModel.of(context).addExerciseItem(userExercise);

                final snack = SnackBar(
                      content: Text("Exercício: \"${_exercise.name }\" adicionado!"),
                      action: SnackBarAction(
                        onPressed: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ToDoListScreen()
                            )
                          );
                        },
                        label: "Visualizar",
                      ),
                      duration: Duration(seconds: 2),
                );
                Scaffold.of(context).removeCurrentSnackBar();
                Scaffold.of(context).showSnackBar(snack);
              });
            },
          ),
        ],
      ),
    );
  }
}

