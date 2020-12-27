import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_pocket_personal_trainer/datas/exercise_data.dart';
import 'package:mini_pocket_personal_trainer/datas/user_exercises_data.dart';
import 'package:mini_pocket_personal_trainer/models/exercise_model.dart';
import 'package:mini_pocket_personal_trainer/screens/home_screen.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ExerciseScreenState(this._exercise);

  final userExercise = UserExercises();
  final quant = TextEditingController();
  final day = TextEditingController();
  final dateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 50.0,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_exercise.name),
        ),
        body: ListView(
          padding: EdgeInsets.only(right: 10, left: 10),
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.8,
              child: Carousel(
                boxFit: BoxFit.fill,
                images: _exercise.images.map((url) {
                  return CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => FlareActor(
                      'assets/animations/WeightSpin.flr',
                      animation: 'Spin',
                    ),
                  );
                }).toList(),
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotBgColor: Colors.transparent,
                dotColor: color,
                autoplay: false,
                onImageTap: (image) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PhotoScreen(
                          _exercise.name, _exercise.images[image])));
                },
              ),
            ),
            Text(
              _exercise.name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Quantidade: "),
              controller: quant,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              _exercise.description ?? "",
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    width: 280,
                    child: MaskedTextField(
                      keyboardType: TextInputType.number,
                      mask: 'xx/xx/xxxx',
                      maxLength: 10,
                      maskedTextFieldController: dateTextController,
                      inputDecoration: InputDecoration(
                          hintText:
                              'Toque no botão ao lado para escolher o dia',
                          labelText: 'Data para fazer o exercício'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(MdiIcons.calendar),
                  iconSize: 30,
                  onPressed: () async {
                    date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.parse("2000-01-01 00:00:00.00000"),
                        lastDate: DateTime(
                            DateTime.now().year, DateTime.december, 31));
                    dateTextController.text =
                        '${date.day}/${date.month}/${date.year}';
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton(
              child: Container(
                padding: EdgeInsets.all(8.0),
                height: 50.0,
                color: Theme.of(context).primaryColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Text(
                      " Adicionar aos meus Exercício ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                userExercise.categoryExercise = _exercise.category;
                userExercise.exerciseId = _exercise.id;
                userExercise.isDone = false;
                userExercise.quantity = int.parse(quant.text);

                if (date == null) {
                  final stringToDate = dateTextController.text.split('/');
                  userExercise.dateMarked = DateTime.parse(
                      '${stringToDate[2]}-${stringToDate[1]}-${stringToDate[0]} 00:00:00.00000');
                } else {
                  userExercise.dateMarked = date;
                }
                userExercise.exerciseData = _exercise;

                if (userExercise.dateMarked == null || quant.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erro ao Salvar exercício!"),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  ExercisesModel.of(context).addExerciseItem(
                      exercise: userExercise,
                      onSuccess: _onSuccess,
                      onFail: _onFail);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Exercício: \"${_exercise.name}\" adicionado!"),
          action: SnackBarAction(
            onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ToDoListScreen())),
          label: "Visualizar",
        ),
        duration: Duration(seconds: 5),
    ));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Erro ao Salvar exercício!"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }
}
