import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mini_pocket_personal_trainer/datas/user_exercises_data.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ExercisesModel extends Model{
  UserModel user;

  List<UserExercises> exercises = List();

  ExercisesModel(this.user);

  static ExercisesModel of(BuildContext context) =>
      ScopedModel.of<ExercisesModel>(context);

  void addExerciseItem(UserExercises exercise){

    exercises.add(exercise);

    Firestore.instance.collection("users")
        .document(user.firebaseUser.uid).collection("myExercises")
        .add(exercise.toMap()).then((doc){
      exercise.categoryId = doc.documentID;
    });

    notifyListeners();
  }


  void removeExercise(UserExercises exercise){
    Firestore.instance.collection("users")
        .document(user.firebaseUser.uid).collection("myExercises")
        .document(exercise.categoryId).delete();

    exercises.remove(exercise);

    notifyListeners();
  }

  void insertExercise(UserExercises exercise, int index){
    exercises.insert(index, exercise);

    Firestore.instance.collection("users")
        .document(user.firebaseUser.uid).collection("myExercises")
        .add(exercise.toMap());

    notifyListeners();

  }

  void getExercises(){
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("myExercises").getDocuments().then((snapshot){
          snapshot.documents.map((doc){
            exercises.add(UserExercises.fromDocument(doc));
          });
    });

    notifyListeners();
  }

  void alterExercise(UserExercises exercise){
    removeExercise(exercise);

    addExerciseItem(exercise);

    notifyListeners();
  }

}