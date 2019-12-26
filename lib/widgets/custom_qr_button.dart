import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomQrButton extends StatelessWidget {
  final String gymName;

  CustomQrButton(this.gymName);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        children: <Widget>[
          Icon(MdiIcons.qrcode),
          Text("Associar-se a esta academia"),
        ],
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              titlePadding: EdgeInsets.all(5.0),
              title: Text(
                "Associando a $gymName",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Utilize este Qr Code gerado automaticamente para começar a frequentar a $gymName",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                      softWrap: true,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: QrImage(
                      data: UserModel.of(context).user.toString(),
                      size: 300,
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                    ),
                  ),
                ],
              ),
              contentPadding: EdgeInsets.all(5.0),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
