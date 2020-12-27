import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mini_pocket_personal_trainer/models/user_model.dart';

class CustomFacebookLoginButton extends StatelessWidget {
  final UserModel model;
  final VoidCallback _onSuccess;
  final VoidCallback _onFail;

  Future<Position> getLocation() async {
    Position current = Position();
    await Geolocator
        .getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((position) {
      current = position;
    });
    return current;
  }

  CustomFacebookLoginButton(this.model, this._onSuccess, this._onFail);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.indigoAccent,
      ),
      child: FlatButton(
        padding: EdgeInsets.all(5.0),
        onPressed: signInWithFacebookLogin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.facebook,
              color: Colors.white,
            ),
            Text(
              "Entrar com Facebook",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }

  signInWithFacebookLogin() async {
    Map<String, dynamic> user = Map();
    Map<String, double> pos = Map();

    await getLocation().then((position) {
      pos["latitude"] = position.latitude;
      pos["longitude"] = position.longitude;
    });

    await Geocoder.local
        .findAddressesFromCoordinates(
            Coordinates(pos["latitude"], pos["longitude"]))
        .then((value) {
      user["address"] = value.first.addressLine;
    });

    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final facebookLoginResult =
        await facebookLogin.logIn(['email', 'public_profile', 'user_hometown']);

    final facebookAuthCred = FacebookAuthProvider.credential(
        facebookLoginResult.accessToken.token);

    var graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,' +
            'email,picture.height(200),hometown&access_token=' +
            '${facebookLoginResult.accessToken.token}');

    final profile = json.decode(graphResponse.body);

    user["name"] = profile["name"];
    user["email"] = profile["email"];
    user["profilePhoto"] = profile["picture"]["data"]["url"];
    user["city"] = profile["hometown"]["name"];
    user["physicalRatings"] = 0;
    user["currentLocation"] = pos;

    model.signInWithFaceBook(
        userData: user,
        credential: facebookAuthCred,
        onSuccess: _onSuccess,
        onFail: _onFail);
  }
}
