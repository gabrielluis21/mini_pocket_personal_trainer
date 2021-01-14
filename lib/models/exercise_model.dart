import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mini_pocket_personal_trainer/datas/user_exercises_data.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ExercisesModel extends Model {
  UserModel user;

  List<UserExercises> exercises = List<UserExercises>.empty();

  ExercisesModel(this.user);

  bool isLoading = false;

  static ExercisesModel of(BuildContext context) =>
      ScopedModel.of<ExercisesModel>(context);

  void addExerciseItem(
      {@required UserExercises exercise,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    exercises.add(exercise);

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("myExercises")
        .add(exercise.toMap())
        .then((doc) {
      exercise.categoryId = doc.id;

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });

    notifyListeners();
  }

  void removeExercise(UserExercises exercise) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("myExercises")
        .doc(exercise.categoryId)
        .delete();

    exercises.remove(exercise);

    notifyListeners();
  }

  void insertExercise(UserExercises exercise, int index) {
    exercises.insert(index, exercise);

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("myExercises")
        .doc(exercise.categoryId)
        .update(exercise.toMap());

    notifyListeners();
  }

  void getAllExercises() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("myExercises")
        .get()
        .then((snapshot) {
      snapshot.docs.map((doc) {
        exercises.add(UserExercises.fromDocument(doc));
      });
    });

    notifyListeners();
  }

  void updateExercise(UserExercises exercise) async {
    isLoading = true;
    notifyListeners();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("myExercises")
        .doc(exercise.categoryId)
        .update(exercise.toMap());

    isLoading = false;
    notifyListeners();
  }
}
