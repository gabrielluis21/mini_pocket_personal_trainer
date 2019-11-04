import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/tiles/category_tile.dart';

class CategoryTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("exercises").getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator(),);
          else {
            var dividedTiles = ListTile.divideTiles(
                tiles: snapshot.data.documents.map(
                    (doc) => CategoryTile(doc)).toList(),
                color: Colors.grey[500],
                context: context,
            ).toList();

            return ListView(children: dividedTiles);
          }
        },
      );
  }
}
