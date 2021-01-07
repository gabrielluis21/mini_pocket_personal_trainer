import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/tiles/category_tile.dart';

class CategoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("exercicios").get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child:  FlareActor(
                'assets/animations/WeightSpin.flr',
                animation: 'Spin',
              ),
          );
          var dividedTiles = ListTile.divideTiles(
            tiles: snapshot.data.docs
                .map((doc) => CategoryTile(doc))
                .toList(),
            color: Colors.grey[500],
            context: context,
          ).toList();

          return ListView(children: dividedTiles);
      },
    );
  }
}
