import 'package:cloud_firestore/cloud_firestore.dart';
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
        builder: (context, child, model){
          String cityUser = model.user["city"];

          return FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("academia").getDocuments(),
            builder: (context, snapshot){
              if(!snapshot.hasData)
                return Center(child: CircularProgressIndicator(),);
              else
                return ListView.builder(
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index){
                      GymData academia = GymData.fromDocument(snapshot.data.documents[index]);
                       if(cityUser.compareTo(academia.city) == 0)
                        return GymTile(academia);
                       else
                         return Center(
                           child: CircularProgressIndicator()
                      );
                    }
                );
            },
          );
        },
      ),
    );
  }
}

