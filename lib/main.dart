import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';
import 'package:conversor/key.dart';

const request = "https://api.hgbrasil.com/finance?format=json&key=$key";

void main() async {

  print(await getData());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    ),
  ));
}

Future<Map> getData() async{
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
  final libraController = TextEditingController();

  double dolar;
  double euro;
  double libra;

  void _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    libraController.text = (real/libra).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar /euro).toStringAsFixed(2);
    libraController.text = (dolar * this.dolar/libra).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    libraController.text = (euro * this.euro/libra).toStringAsFixed(2);
  }

  void _libraChanged(String text){
    double libra = double.parse(text);
    realController.text = (libra * this.libra).toStringAsFixed(2);
    dolarController.text = (libra * this.libra / dolar).toStringAsFixed(2);
    euroController.text = (libra * this.libra / euro).toStringAsFixed(2);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$ Conversor \S'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text('Carregando dados...',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25),
                  textAlign: TextAlign.center,
                  ),
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text('Erro nos dados...',
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              }else{

                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                libra = snapshot.data["results"]["currencies"]["GBP"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 120, color: Colors.amber),
                      buildText('Real', 'R\$', realController, _realChanged),
                      Divider(),
                      buildText('Dólar', 'USD', dolarController, _dolarChanged),
                      Divider(),
                      buildText('Euro', 'EUR', euroController, _euroChanged),
                      Divider(),
                      buildText('Libra', 'GBP', libraController, _libraChanged)
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget buildText(String label, String prefix, TextEditingController c, Function f){
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: label,
          prefixText: prefix + ' ',
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder()
      ),
      style: TextStyle(
          color: Colors.amber, fontSize: 25
      ),
      onChanged: f,
    );
  }
}
