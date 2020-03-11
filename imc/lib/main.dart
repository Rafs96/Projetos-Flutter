import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
      home: Home(),
    )
  );
}

class  Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados!";

  void _resetFields(){
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe seus dados!";
      _formKey = GlobalKey<FormState>();
    });
  }


  void _calculoIMC(){
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      if(imc < 18.6){
        _infoText = "Abaixo do Peso (${imc.toStringAsPrecision(4)})";
      }
      else if(imc >= 18.6 && imc < 24.9){
        _infoText = "Peso Ideal (${imc.toStringAsPrecision(4)})";
      }
      else if(imc >= 24.9 && imc < 29.9){
        _infoText = "Levemente acima do Peso (${imc.toStringAsPrecision(4)})";
      }
      else if(imc >= 29.9 && imc < 34.9){
        _infoText = "Obesidade Grau I (${imc.toStringAsPrecision(4)}))";
      }
      else if(imc >= 34.9 && imc < 39.9){
        _infoText = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      }
      if(imc >= 40.0){
        _infoText = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Calculadora de IMC", 
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          ),
        ],
      ),
      backgroundColor: Colors.yellow,
      body: SingleChildScrollView(
        padding:  EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child:Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          Icon(Icons.person_outline, size:  140.0, color: Colors.purple,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Peso (kg)",
              labelStyle: TextStyle(color: Colors.purple)
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple, fontSize: 30.0 
            ),
            controller: weightController,
            validator: (value) {
              if(value.isEmpty){
                return "Insira seu peso";
              }
              return '';
            },
          ),
          TextFormField(keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Altura (cm)",
              labelStyle: TextStyle(color: Colors.purple)
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple, fontSize: 30.0 
            ),
            controller: heightController,
            validator: (value){
              if(value.isEmpty){
                return "Insira sua altura";
              }
              return '';

            },
          ),
          Padding(
            padding: EdgeInsets.only(top : 20.0, bottom : 20.0),
            child: Container(
            height: 100.0,
              child : RaisedButton(
                onPressed: (){
                  if (_formKey.currentState.validate()) {
                    _calculoIMC();
                  }
                },
              
                child: Text(
                "Calcular IMC", 
                style: TextStyle(
                    color: Colors.yellow, fontSize: 25.0, fontStyle: FontStyle.italic
                ),
               ),
              color: Colors.purple,
              ),
            ),
          ),
          Text(_infoText, textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 25.0),
          ),
          ],
          ),
        ),
      ),
    );
  }
}