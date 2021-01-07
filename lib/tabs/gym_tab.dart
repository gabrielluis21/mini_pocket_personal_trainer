import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/gym_data.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/tiles/gym_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class GymTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          String cityUser = model.user["city"];

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection("academia").get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child:  FlareActor(
                      'assets/animations/WeightSpin.flr',
                      animation: 'Spin',
                      alignment: Alignment.center,
                    ),
                );
              return ListView.builder(
                padding: EdgeInsets.all(4.0),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  GymData academia =
                       GymData.fromDocument(snapshot.data.docs[index]);

                  return GymTile(academia);
                }
              );
            },
          );
        },
      ),
    );
  }
}
