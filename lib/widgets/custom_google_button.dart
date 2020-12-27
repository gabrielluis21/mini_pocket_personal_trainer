import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';

class CustomGoogleLoginButton extends StatelessWidget {
  final UserModel model;
  final VoidCallback _onSuccess;
  final VoidCallback _onFail;

  Future<Position> getLocation() async {
    Position current = Position();
    await Geolocator.checkPermission().then(
      (value) async {
        if(value.index == 3){
          await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              forceAndroidLocationManager: true)
              .then((position) {
            current = position;
          });
        }
      });

    return current;
  }

  CustomGoogleLoginButton(this.model, this._onSuccess, this._onFail);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      padding: EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.red,
      ),
      child: FlatButton(
        padding: EdgeInsets.all(5.0),
        onPressed: singUpWithGoogle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.google,
              color: Colors.white,
            ),
            Text(
              "Entrar com Google",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  singUpWithGoogle() async {
    Map<String, dynamic> userData = Map();
    Map<String, double> pos = Map();

    await getLocation().then((position) {
      pos["latitude"] = position.latitude;
      pos["longitude"] = position.longitude;
    });

    await Geocoder.local
        .findAddressesFromCoordinates(
            Coordinates(pos["latitude"], pos["longitude"]))
        .then((value) {
      userData["address"] = value.first.addressLine;
    });

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    userData["name"] = googleSignInAccount.displayName;
    userData["email"] = googleSignInAccount.email;
    userData["profilePhoto"] = googleSignInAccount.photoUrl;
    userData["currentPosition"] = pos;
    userData["physicalRatings"] = 0;

    model.signInWithGoogle(
        userData: userData,
        credential: credential,
        onFail: _onFail,
        onSuccess: _onSuccess);
  }
}
