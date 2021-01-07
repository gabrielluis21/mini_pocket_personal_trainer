import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomQrButton extends StatefulWidget {
  final String gymName;

  CustomQrButton(this.gymName);

  @override
  _CustomQrButtonState createState() => _CustomQrButtonState(gymName);
}

class _CustomQrButtonState extends State<CustomQrButton> {
  final String gymName;

  _CustomQrButtonState(this.gymName);

  Widget contentOfQrDialog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: Text(
           "Utilize este Qr Code gerado automaticamente para começar a frequentar esta academia",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            softWrap: true,
           ),
        ),
        SizedBox(height: 10.0),
        Container(
          width: 350,
          height: 350,
          child: QrImage(
            data: UserModel.of(context).user.toString(),
            size: 300,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
          ),
        ),
     ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        children: <Widget>[
          Icon(MdiIcons.qrcode),
          Text("Associar-se a esta academia"),
        ],
      ),
      onPressed: () => showQrCodeDialog(),
    );
  }

  void showQrCodeDialog(){
    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          titlePadding: EdgeInsets.all(5.0),
          title: Text("Associando a $gymName",
           style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          contentPadding: EdgeInsets.all(8.0),
          content: contentOfQrDialog(),
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
  }
}

