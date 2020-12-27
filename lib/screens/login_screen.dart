import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/home_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/signup_screen.dart';
import 'package:mini_pocket_personal_trainer/widgets/custom_facebook_button.dart';
import 'package:mini_pocket_personal_trainer/widgets/custom_google_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState(){

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));

    return Scaffold(
        key: _scaffoldKey,
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(8),
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 200.0,
                      width: 300.0,
                    ),
                  ),
                  Text(
                    "Pocket Personal Trainer",
                    style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: "E-mail",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            gapPadding: 5.0)),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@"))
                        return "E-mail invalido!";
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: "Senha",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            gapPadding: 5.0)),
                    obscureText: true,
                    controller: _senhaController,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return "Senha invalida!";
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          child: Text(
                            "Esqueci minha senha",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onPressed: () {
                            if (_emailController.text.isEmpty)
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Insira o seu e-mail para recuperação!"),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 3)));
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Confira seu email!"),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  duration: Duration(seconds: 3)));
                              model.recoverPassword(_emailController.text);
                            }
                          })),
                  Container(
                    height: 45.0,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: FlatButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      textColor: Colors.white,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          model.logIn(
                              email: _emailController.text,
                              passwd: _senhaController.text,
                              onFail: _onFail,
                              onSuccess: _onSuccess);
                        }
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  FlatButton(
                    child: Text("Criar nova conta",
                        style: TextStyle(fontSize: 18.0)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpScreen()));
                    },
                  ),
                  Divider(
                    height: 4.0,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CustomGoogleLoginButton(model, _onSuccess, _onFail),
                      Divider(
                        height: 4.0,
                      ),
                      CustomFacebookLoginButton(model, _onSuccess, _onFail),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }

  void _onSuccess() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Falha ao realizar login"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
