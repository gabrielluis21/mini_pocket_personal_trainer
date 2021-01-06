import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/screens/login_screen.dart';

class HowToUseScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/attention_sign.png',
              height: 350,
              width: 150
          ),
          SizedBox(height: 10,),
          Text('Este aplicativo é apenas uma ferramenta para ajudar nos seus treinos!',
            softWrap: true,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10,),
          Text('Todos os exercícios apresentados são apenas ilustrativos, consulte seu personal para realziação correta dos mesmos',
            softWrap: true,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          RaisedButton(
            child: Text('Continuar'),
            color: Theme.of(context).primaryColor,
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen())
            )
          )
        ],
      ),
    );
  }
}
