import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/screens/home_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            if(model.isLoading)
              return Center(child: CircularProgressIndicator(),);

            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(10.0),
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      "images/logo.png",
                      height: 150.0,
                      width: 300.0,
                    ),
                  ),
                  Text("Pocket Personal Trainer",
                    style: TextStyle(fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    decoration: InputDecoration(labelText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (text){
                      if(text.isEmpty || !text.contains("@"))
                        return "E-mail invalido!";
                    },
                  ),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Senha"),
                    obscureText: true,
                    controller: _senhaController,
                    validator: (text){
                      if(text.isEmpty || text.length < 6)
                        return "Senha invalida!";
                    },
                  ),
                  SizedBox(height: 10.0,),
                  Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          child: Text("Esqueci minha senha"),
                          onPressed: (){
                            if(_emailController.text.isEmpty)
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text("Insira o seu e-mail para recuperação!"),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 3))
                              );
                            else{
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text("Confira seu email!"),
                                      backgroundColor: Theme.of(context).primaryColor,
                                      duration: Duration(seconds: 3))
                              );
                              model.recoverPassword(_emailController.text);
                            }
                          }
                      )
                  ),
                  SizedBox(height: 10.0,),
                  RaisedButton(
                    child: Text("Entrar",
                      style: TextStyle(fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    textColor: Colors.white,
                    onPressed: () {
                      if(_formKey.currentState.validate()){
                          model.login(email: _emailController.text,
                            passwd: _senhaController.text, onFail: _onFail,
                            onSuccess: _onSuccess);
                      }
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 5.0,),
                  FlatButton(
                    child: Text("Criar nova conta"),
                    onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignUpScreen())
                      );
                    },
                  ),
                  Divider(
                    height: 4.0,
                    color: Colors.black,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.only(left: 4.0, right: 4.0),
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
                    color: Colors.black,
                    onPressed: (){
                      model.signInWithGoogle();
                    },
                  )
                ],
              ),
            );
          },
        )
    );
  }
void _onSuccess(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen()
      )
    );
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao realizar login"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      )
    );
  }
}
