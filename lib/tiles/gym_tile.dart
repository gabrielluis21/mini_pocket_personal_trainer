import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/gym_data.dart';
import 'package:mini_pocket_personal_trainer/screens/gym_screen.dart';

class GymTile extends StatelessWidget {
  final GymData academia;

  GymTile(this.academia);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: academia.images.isNotEmpty ?
               Image.network(
                academia.images.first,
                fit: BoxFit.cover,
                height: 100,
              ) : Image.asset("assets/images/empty.png"),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      academia.name,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      academia.address,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => GymScreen(academia)));
      },
    );
  }
}
