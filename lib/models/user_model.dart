import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User firebaseUser;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  Map<String, dynamic> user = Map();

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    _getCurrentUser();
    super.addListener(listener);
  }

  signInWithFaceBook(
      {@required Map<String, dynamic> userData,
      @required AuthCredential credential,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth.signInWithCredential(credential).then((authResult) async {
      firebaseUser = authResult.user;
      userData["uid"] = firebaseUser.uid;
      await _saveUserData(userData);
      onSuccess();

      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  updateProfile(
      {@required Map<String, dynamic> userData,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    this._updateUserData(userData).then((user) {
      this.user = userData;

      firebaseUser.updatePassword(password);

      onSuccess();

      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();

      isLoading = false;
      notifyListeners();
    });
  }

  signInWithGoogle(
      {@required Map<String, dynamic> userData,
      @required AuthCredential credential,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth.signInWithCredential(credential).then((authResult) async {
      firebaseUser = authResult.user;
      userData["uid"] = firebaseUser.uid;
      await _saveUserData(userData);
      onSuccess();

      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  _signOutFacebook() async {
    await facebookLogin.logOut();
    _auth.signOut();
  }

  _signOutGoogle() async {
    await googleSignIn.signOut();
    _auth.signOut();
  }

  userSignOut() {
    switch (firebaseUser.providerData.first.providerId) {
      case 'facebook.com':
        _signOutFacebook();
        break;
      case 'google.com':
        _signOutGoogle();
        break;
      default:
        _logOut();
        break;
    }
  }

  signUp(
      {@required Map<String, dynamic> userData,
      @required String email,
      @required String passwd,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(email: email, password: passwd)
        .then((authResult) async {
      firebaseUser = authResult.user;
      userData["uid"] = firebaseUser.uid;
      await _saveUserData(userData);
      onSuccess();

      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  logIn(
      {@required String email,
      @required String passwd,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    await _auth
        .signInWithEmailAndPassword(email: email, password: passwd)
        .then((authResult) {
      this.firebaseUser = authResult.user;
      _getCurrentUser();
      onSuccess();

      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  _logOut() async {
    await _auth.signOut();

    user = Map();
    firebaseUser = null;

    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  recoverPassword(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> _updateUserData(Map<String, dynamic> userData) async {
    this.user = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .update(userData);
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.user = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .set(userData);
  }

  Future<Null> _getCurrentUser() async {
    if (firebaseUser == null) firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .get()
          .then((user) {
        this.user = user.data();
      });
    }
  }

  Future<bool> autoLogin() async{
    bool isAutoLogged = false;
    try{
      _getCurrentUser();
      notifyListeners();

      isAutoLogged = true;
      notifyListeners();
    }catch(e){
      print(e);
    }
    return isAutoLogged;
  }
}
