import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';

class SharePhotoScreen extends StatelessWidget {
  final File imageUrl;

  SharePhotoScreen(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(imageUrl.path);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(child: Image.file(imageUrl)),
    );
  }
}
