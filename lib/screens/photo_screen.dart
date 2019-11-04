import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  final String exerciseName;
  final String exerciseImage;

  PhotoScreen(this.exerciseName, this.exerciseImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exerciseName),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: Image.network(exerciseImage)
      ),
    );
  }
}
