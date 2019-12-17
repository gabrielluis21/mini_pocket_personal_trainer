import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final String version = "0.0.1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sobre"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 15.0,),
          Text("Versão: $version",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),),
          SizedBox(height: 15.0,),
          Text("Este aplicativo, foi idealizado para que o seu treino",
          style: TextStyle(fontSize: 14.0),),
          Text("torne-se mais prático e informátivo",
              style: TextStyle(fontSize: 14.0)),
          Text("contendo informações sobre os exercícios",
              style: TextStyle(fontSize: 14.0)),
          Text("contidos no seguinte livro: ",
              style: TextStyle(fontSize: 14.0)),
          SizedBox(height: 8.0,),
          Center(
            child: Column(
              children: <Widget>[
                Text("Musculação", style: TextStyle(fontSize: 18.0,
                color: Colors.red, fontWeight: FontWeight.bold),),
                Text("Anatomia ilustrada",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),),
                Text("Guia prático para aumento de Massa muscular",
                style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),),
                Text("por Graig Ramsay", style: TextStyle(fontSize: 14.0,),),
              ],
            ),
          ),
          SizedBox(height: 25.0,),
          Divider(height: 5.0,),
          Text("Criado por: "),
          Text("Prof.º: Luis Gabriel da Silva - CREF: 008087G-SP"),
          Text("e"),
          Text("Gabriel Luis da Silva - Analista de sistemas"),
        ],
      ),
    );
  }
}
