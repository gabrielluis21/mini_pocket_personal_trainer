import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon, this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 32,
                color: controller.page.round() == page ?
                Colors.white : Colors.black,
              ),
              SizedBox(
                child: Text(text,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: controller.page.round() == page ?
                    FontStyle.italic : FontStyle.normal,
                    color: controller.page.round() == page ?
                    Colors.white : Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
