import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/exercise_data.dart';
import 'package:mini_pocket_personal_trainer/screens/exercise_screen.dart';

class ExerciseTile extends StatelessWidget {
  final ExerciseData exerciseData;

  ExerciseTile(this.exerciseData);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: exerciseData.images.isNotEmpty
                  ? Image.network(
                      exerciseData.images.first,
                      fit: BoxFit.cover,
                      height: 100.0,
                    )
                  : Image.asset("assets/images/empty.png"),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      exerciseData.name,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ExerciseScreen(exerciseData)));
      },
    );
  }
}
