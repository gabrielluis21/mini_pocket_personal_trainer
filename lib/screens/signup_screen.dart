import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwdController = TextEditingController();
  String profilePhoto;
  ImagePicker picker;


  @override
  void initState() {
    super.initState();
  }

  Future<Position> getLocation() async {
    Position current = Position();
    await Geolocator
        .getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: true
        ).then((position) {
          current = position;
        });
    return current;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastrar"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: profilePhoto != null
                              ? Image.network(profilePhoto)
                              : AssetImage("images/person.png")),
                    ),
                  ),
                  onTap: () {
                      picker.getImage(source: ImageSource.camera)
                        .then((file) async {
                      if (file == null) return;
                      UploadTask task = FirebaseStorage.instance
                          .ref()
                          .child("photos")
                          .child("profilePhotos")
                          .child(model.firebaseUser.uid +
                              DateTime.now().millisecondsSinceEpoch.toString())
                          .putFile(new File(file.path));
                      TaskSnapshot snap = task.snapshot;
                      setState(() async {
                        profilePhoto = await snap.ref.getDownloadURL();
                      });
                    });
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Nome completo"),
                  validator: (text) {
                    if (text.isEmpty) return "Insira o seu endereço";
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: "Endereço"),
                  validator: (text) {
                    if (text.isEmpty) return "Insira o seu endereço";
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: "Cidade"),
                  validator: (text) {
                    if (text.isEmpty) return "Insira a sua cidade";
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text.isEmpty || !text.contains("@"))
                      return "E-mail inválido";
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _passwdController,
                  decoration: InputDecoration(labelText: "Senha"),
                  validator: (text) {
                    if (text.isEmpty || text.length < 6)
                      return "Senha inválida!";
                  },
                  obscureText: true,
                ),
                SizedBox(
                  height: 16.0,
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Map<String, double> pos = Map();
                      await getLocation().then((position) {
                        pos["latitude"] = position.latitude;
                        pos["longitude"] = position.longitude;
                      });
                      Map<String, dynamic> user = {
                        "name": _nameController.text,
                        "address": _addressController.text,
                        "email": _emailController.text,
                        "profilePhoto": profilePhoto,
                        "city": _cityController.text,
                        "currentLocation": pos,
                        "physicalRatings": 0
                      };
                      await model.signUp(
                          userData: user,
                          email: _emailController.text,
                          passwd: _passwdController.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail);
                    }
                  },
                  child: Text(
                    "Criar Conta",
                    textAlign: TextAlign.center,
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
