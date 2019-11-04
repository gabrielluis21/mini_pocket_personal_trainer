import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:geolocator/geolocator.dart';

class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  Map<String, dynamic> user = Map();

  bool isLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener){
    _getCurrentUser();
    super.addListener(listener);

  }

  updateProfile({@required Map<String, dynamic> userData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail}){
    isLoading = true;

    notifyListeners();

    this.updateUserData(userData).then((user){
      this.user = userData;
      onSuccess;
      isLoading = false;



      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  signUp({@required Map<String, dynamic> userData,
    @required String passwd, @required VoidCallback onSuccess,
    @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(email: userData["email"],
        password: passwd).then((user) async{
      firebaseUser = user;
      userData["uid"] = firebaseUser.uid;
      await _saveUserData(userData);
      onSuccess();

      isLoading = false;
      notifyListeners();

    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });

  }

  login({@required String email, @required String passwd,
    @required VoidCallback onSuccess, @required VoidCallback onFail}) async{

    isLoading = true;
    notifyListeners();

    await _auth.signInWithEmailAndPassword(email: email,
        password: passwd).then((user) async{
      this.firebaseUser = user;
      _getCurrentUser();
      onSuccess();

      isLoading = false;
      notifyListeners();
    }).catchError((e){

      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  logOut() async{
    await _auth.signOut();

    user = Map();
    firebaseUser = null;

    notifyListeners();
  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  recoverPassword(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> updateUserData(Map<String, dynamic> userData) async{
    await Firestore.instance.collection("users")
        .document(firebaseUser.uid).updateData(userData);
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.user = userData;
    await Firestore.instance.collection("users")
        .document(firebaseUser.uid).setData(userData);
  }

   _getCurrentUser() async{
    if(firebaseUser != null)
      firebaseUser = await _auth.currentUser();
    if(firebaseUser != null){
      if(user["name"] == null){
        await Firestore.instance.collection("users").document(firebaseUser.uid).get().then((user){
          this.user["uid"] = firebaseUser.uid;
          this.user = user.data;
        });

      }
    }
  }

  signInWithGoogle() async {
    Map<String, dynamic> userData = Map();
    isLoading = true;
    notifyListeners();

    GoogleSignInAccount googleAccount = _googleSignIn.currentUser;
    if(googleAccount == null)
      googleAccount = await _googleSignIn.signInSilently();
    if(googleAccount == null)
      googleAccount = await _googleSignIn.signIn();
    if(await _auth.currentUser() == null){
      GoogleSignInAuthentication credentials = await _googleSignIn.currentUser.authentication;
      await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: credentials.idToken, accessToken: credentials.accessToken));
      firebaseUser = await _auth.currentUser();
    }

    userData["name"] = googleAccount.displayName;
    userData["email"] = googleAccount.email;
    userData["profilePhoto"] = googleAccount.photoUrl;
    userData["uid"] = firebaseUser.uid;
    _saveUserData(userData);

    isLoading = false;
    notifyListeners();
  }

}