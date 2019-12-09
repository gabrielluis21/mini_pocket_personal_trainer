import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:http/http.dart' as http;


class CustomFacebookLoginButton extends StatelessWidget {
  final UserModel model;
  final VoidCallback _onSuccess;
  final VoidCallback _onFail;

  CustomFacebookLoginButton(this.model, this._onSuccess, this._onFail);

  Future<Position> getLocation() async {
    Position current = Position();
    await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high,
        locationPermissionLevel: GeolocationPermission.locationAlways)
        .then((position){
      current = position;
    });
    return current;
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.only(right: 4.0),
      onPressed: signInWithFacebookLogin,
      color: Colors.indigoAccent,
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          Icon(FontAwesomeIcons.facebook,
            color: Colors.white,),
          Text(" Entrar com Facebook",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),)
        ],),
      ),
    );
  }

  signInWithFacebookLogin() async{
    Map<String, dynamic> user = Map();
    Map<String, double> pos = Map();

    await getLocation().then((position) {
      pos["latitude"] = position.latitude;
      pos["longitude"] = position.longitude;
    });

    await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(pos["latitude"], pos["longitude"])).then((value){
      user["address"] = value.first.addressLine;
    });

    final FacebookLoginResult result = await _handleFBSignIn();

    var graphResponse = await http.get(
     'https://graph.facebook.com/v2.12/me?fields=name,'+
         'email,picture.height(200),hometown&access_token=${result.accessToken.token}');

    final profile = json.decode(graphResponse.body);

    user["name"] = profile["name"];
    user["email"] = profile["email"];
    user["profilePhoto"] = profile["picture"]["data"]["url"];
    user["city"] = profile["hometown"];
    user["currentLocation"] = pos;


    final facebookAuthCred = FacebookAuthProvider
        .getCredential(accessToken: result.accessToken.token);

    model.signInWithFaceBook(userData: user, credential: facebookAuthCred,
        onSuccess: _onSuccess, onFail: _onFail);
  }

  Future<FacebookLoginResult> _handleFBSignIn() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
    await facebookLogin.logIn(['email', 'public_profile' , 'user_hometown']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        print("Logged In");
        break;
    }
    return facebookLoginResult;
  }


}
