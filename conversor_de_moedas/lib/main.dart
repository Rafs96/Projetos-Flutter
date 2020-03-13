import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


const request = "https://api.hgbrasil.com/finance?key=75e7a667";

void main() async {

  print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    ),
  )
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController(); 
  double dolar;
  double euro;

  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);

  }
  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar/euro).toStringAsFixed(2);

  }
  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro/dolar).toStringAsFixed(2);
  }
  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text("\$ Conversor de Moeda \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child : Text( "Carregando Dados ...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0
                  ),
                textAlign: TextAlign.center,
                )
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child : Text("Erro de Carregamento de Dados",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0
                    ),
                  textAlign: TextAlign.center,
                  )
                );
              }
              else{

                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children : <Widget>[
                      Icon(Icons.monetization_on, size: 150.0 , color: Colors.amber),
                      biuldTextField("Reais", "R\$", realController, _realChanged),
                      
                      Divider(),
                      biuldTextField("Dolar", "US\$", dolarController, _dolarChanged),
                    
                      Divider(),
                      biuldTextField("Euros", "Euro", euroController, _euroChanged),
                      
                    ], 
                  ),
                );
              }
          }
        }
      )
    );
  }
}

Widget biuldTextField(String label, String prefix, TextEditingController c, Function f){  
  return TextField(
    controller: c,
    decoration : InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix
    ),
    style: TextStyle(
      color: Colors.amber, fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}


