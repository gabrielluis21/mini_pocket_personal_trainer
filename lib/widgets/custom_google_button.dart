

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';

class CustomGoogleLoginButton extends StatelessWidget {

  final UserModel model;
  VoidCallback _onSuccess;
  VoidCallback _onFail;
  final Position _location;

  CustomGoogleLoginButton(this.model, this._location, this._onSuccess, this._onFail);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.only(left: 4.0, right: 4.0),
      onPressed: singUpWithGoogle,
      color: Colors.red,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(FontAwesomeIcons.google,
              color: Colors.white,),
            Text(" Entrar com google",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),)
          ],
        ),
      ),

    );
  }
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _autoPassword = "21JEC87221";

  singUpWithGoogle() async {
    Map<String, dynamic> userData = Map();

    GoogleSignInAccount googleAccount = _googleSignIn.currentUser;
    if(googleAccount == null)
      googleAccount = await _googleSignIn.signInSilently();
    if(googleAccount == null)
      googleAccount = await _googleSignIn.signIn();

    userData["name"] = googleAccount.displayName;
    userData["email"] = googleAccount.email;
    userData["profilePhoto"] = googleAccount.photoUrl;
    userData["currentLocation"] = _location;

    model.signUp(userData: userData, passwd: _autoPassword,onFail: _onFail, onSuccess: _onSuccess);
  }

}
