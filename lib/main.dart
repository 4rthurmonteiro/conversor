import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=";

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

  double dolar;
  double euro;

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

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 120, color: Colors.amber),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Real',
                          prefixText: 'R\$',
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder()
                        ),
                        style: TextStyle(
                          color: Colors.amber, fontSize: 25
                        ),
                      ),
                      Divider(),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Dólar',
                            prefixText: 'USD',
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder()
                        ),
                        style: TextStyle(
                            color: Colors.amber, fontSize: 25
                        ),
                      ),
                      Divider(),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Euro',
                            prefixText: 'EUR',
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder()
                        ),
                        style: TextStyle(
                            color: Colors.amber, fontSize: 25
                        ),
                      )
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
