import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/exercise_data.dart';
import 'package:mini_pocket_personal_trainer/tiles/exercise_tile.dart';

class CategoryScreen extends StatelessWidget {

  final DocumentSnapshot _snapshot;

  CategoryScreen(this._snapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_snapshot.data["title"]),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Firestore.instance.collection("exercises")
            .document(_snapshot.documentID).collection("item").getDocuments(),
        builder: (context, snapshot){
          if(!snapshot.hasData)
            return Center(child: CircularProgressIndicator(),);
          else{
            return ListView.builder(
                padding: EdgeInsets.all(4.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  ExerciseData exercise = ExerciseData.fromDocument(snapshot.data.documents[index]);
                  exercise.category = _snapshot.documentID;

                  return ExerciseTile(exercise);
                }
            );
          }

        },
      )
    );
  }
}

