import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseData {
  String category;

  String id;

  String name;
  String description;

  List images;

  ExerciseData.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    name = doc.data()["name"];
    description = doc.data()["description"];
    images = doc.data()["images"];
  }

  ExerciseData.fromMap(Map exercise) {
    category = exercise["category"];
    name = exercise["name"];
    description = exercise["description"];
    images = exercise["images"];
  }

  Map<String, dynamic> toResumeMap() {
    return {"category": category, "name": name, "description": description};
  }
}
