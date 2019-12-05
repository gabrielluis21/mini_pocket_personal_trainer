import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  Map<String, dynamic> user = Map();

  bool isLoading = false;

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
        password: passwd).then((authResult) async{
      firebaseUser = authResult.user;
      userData["uid"] = firebaseUser.uid;
      _saveUserData(userData);
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
        password: passwd).then((authResult){

      this.firebaseUser = authResult.user;
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

  updateUserData(Map<String, dynamic> userData) async{
    this.user = userData;
    CollectionReference collection = Firestore.instance.collection("users");
    await collection.document(firebaseUser.uid).setData(userData, merge: true);
  }

  _saveUserData(Map<String, dynamic> userData) async {
    this.user = userData;
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(Firestore.instance.collection("users").document(firebaseUser.uid), {
        'profilePhoto': userData["profilePhoto"],
        'name':  userData["name"],
        'address':  userData["address"],
        'email':  userData["email"],
        'currentLocation':  userData["currentLocation"]
      });
    });

  }

   _getCurrentUser() async{
    if(firebaseUser != null)
      firebaseUser = await _auth.currentUser();
    if(firebaseUser != null){
        await Firestore.instance.collection("users").document(firebaseUser.uid).get().then((user){
          this.user["uid"] = firebaseUser.uid;
          this.user = user.data;
        });
    }
  }

}