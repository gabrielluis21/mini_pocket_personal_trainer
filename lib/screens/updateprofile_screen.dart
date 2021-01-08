import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwdController = TextEditingController();
  String profilePhoto;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50.0),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Atualizar Cadastro"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoggedIn()) {
              _nameController.text = model.user["name"];
              _addressController.text = model.user["address"];
              _emailController.text = model.user["email"];
              profilePhoto = model.user["profilePhoto"];
              _cityController.text = model.user["city"];
            }

            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );

            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.only(left: 8, right: 8, top: 10),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
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
                        child: CircleAvatar(
                            maxRadius: 75.0,
                            backgroundImage: model.user["profilePhoto"] != null
                                ? NetworkImage(
                                    model.user["profilePhoto"],
                                  )
                                : AssetImage("assets/images/person.png")),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Nome completo"),
                    validator: (text) {
                      if (text.isEmpty) return "Insira o seu endereço";
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: "Endereço"),
                    validator: (text) {
                      if (text.isEmpty) return "Insira o seu endereço";
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(labelText: "Cidade"),
                    validator: (text) {
                      if (text.isEmpty) return "Insira a sua cidade";
                    },
                  ),
                  SizedBox(
                    height: 10.0,
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
                    height: 8.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Nova senha"),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    controller: _passwdController,
                    maxLength: 8,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return "Senha inválida, a senha tem que ter entre 6 a 8 caracteres";
                    },
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _updateProfile,
          icon: Icon(Icons.update),
          label: Text('Atualizar conta')),
      ),
    );
  }

  void _updateProfile() async{
    if (_formKey.currentState.validate()) {
       Map<String, dynamic> user = {
        "name": _nameController.text,
        "address": _addressController.text,
        "email": _emailController.text,
        "profilePhoto": profilePhoto,
      "city": _cityController.text
      };
      await UserModel.of(context).updateProfile(
        userData: user,
        password: _passwdController.text,
        onSuccess: _onSuccess,
        onFail: _onFail);
    }
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
