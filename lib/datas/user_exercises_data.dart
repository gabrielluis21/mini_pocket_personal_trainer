import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_pocket_personal_trainer/datas/exercise_data.dart';

class UserExercises {
  String categoryId;

  String categoryExercise;
  String exerciseId;
  int quantity;
  DateTime dateMarked;
  DateTime doneIn;
  bool isDone = false;

  ExerciseData exerciseData;

  UserExercises();

  UserExercises.fromDocument(DocumentSnapshot doc) {
    categoryId = doc.id;
    categoryExercise = doc.data()["category"];
    exerciseId = doc.data()["exerciseId"];
    quantity = doc.data()["quantity"];
    isDone = doc.data()["isDone"];
    dateMarked = DateTime.parse(doc.data()["date"]);
    doneIn = isDone ? DateTime.parse(doc.data()["doneIn"]) : dateMarked;
    exerciseData = ExerciseData.fromMap(doc.data()["exercise"]);
    exerciseData.id = exerciseId;
  }

  Map<String, dynamic> toMap() {
    return {
      "category": categoryExercise,
      "exerciseId": exerciseId,
      "quantity": quantity,
      "isDone": isDone,
      "date": dateMarked.toString(),
      "doneIn": doneIn.toString(),
      "exercise": exerciseData.toResumeMap()
    };
  }
}
