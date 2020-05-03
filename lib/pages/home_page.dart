import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _usuario = "";
  bool _flag = true;
  bool _showCard = false;
  String _nombre = "";
  String _id = "";
  bool _flagText = true;
  TextEditingController _controlTexto = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Respuesta de API"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: <Widget>[
            SizedBox(height: 80,),
            _getUser(),
            SizedBox(height: 30,),
            _botonSendAPI(context),
            SizedBox(height: 30,),
            _widgetresponseAPI(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.clear),
        onPressed: (){
          print("Floating Pressed!");
          setState(() {
            _usuario = "";
            _flag = true;
            _controlTexto.clear();
            _showCard = false;
            _flagText = true;
          });
        }
      ),
    );
  }

  Widget _getUser() {
    return TextField(
      enabled: _flagText,
      controller: _controlTexto,
      maxLength: 7,
      onChanged: (valor){
        bool valFlag = false;
        if(valor.length>=1){
          valFlag = false;
        }else{
          valFlag =true;
        }
        print(valor);
        setState(() {
          _usuario=valor;
          _flag = valFlag;
        });
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: "Número de empleado",
        suffixIcon: Icon(Icons.account_circle)
      ),
    );
  }

  Widget _botonSendAPI(BuildContext context) {
    return RaisedButton(
      child: Text("Enviar Usuario"),
        onPressed: (_flag) ? null : (){
          setState(() {
            _flag = true;
            _flagText = false;
          });
          print("Enviando Usuario: $_usuario");
          FocusScope.of(context).requestFocus(new FocusNode());
          _responseAPI();
        },
      );
  }

  Future<Null> _responseAPI() async{
    final url = "http://datamx.io/api/action/datastore_search_sql?sql=SELECT%20*%20from%20%22df9d4714-a5a3-469f-ae9a-d4c28b34d954%22%20WHERE%20_id%20=%20$_usuario";
    final res = await http.get(url);
    print(res.statusCode);
    final jsonParse = json.decode(res.body);
    setState(() {
      _nombre = jsonParse["result"]["records"][0]["nombre"];
      _id = jsonParse["result"]["records"][0]["_id"].toString();
      _showCard = true;
    });
  }

  Widget _widgetresponseAPI() {
    if (_showCard){
      return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 20,
      child: Container(
        width: 500,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("ID: $_id"),
            Text('Nombre: $_nombre'),
            Text("Apellidos: "),
            Text("Fecha de Ingreso: ")
          ],
        ),
      ),
    );
    }
    else{
      return Text("");
    }
  }
}