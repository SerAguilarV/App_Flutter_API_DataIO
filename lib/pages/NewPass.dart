import 'package:api_node/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class NewPass extends StatefulWidget {
  final Data datos;
  NewPass(this.datos);
  static const String id = "/newPass";
  @override
  _NewPassState createState() => _NewPassState();
}

class _NewPassState extends State<NewPass> {
  String _newPass = "";
  String _newPass2 = "";
  bool _flagLenPass = false;
  bool _flagLenPass2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child:AppBar(
          title: Center(child: Text("Cambio de Password de ${widget.datos.usuario}")),
          backgroundColor: Colors.redAccent,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: <Widget>[
            _newPassTextField(),
            SizedBox(height: 50,),
            _newPassTextField2(),
            SizedBox(height: 50,),
            _botonEnviarNewPass(context),
          ],
        ),
      ),
    );
  }

  Widget _newPassTextField() {
    return TextField(
      obscureText: true,
      onChanged: (value){
        _newPass = value;
        if(_newPass.length<=7){
          _flagLenPass = false;
          print(_flagLenPass);
        }else{
          _flagLenPass = true;
          print(_flagLenPass);
        }
        setState(() {});
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: "Nueva Contraseña",
        suffixIcon: Icon(Icons.security)
      ),
    );
  }

  Widget _newPassTextField2() {
    return TextField(
      enabled: _flagLenPass,
      obscureText: true,
      onChanged: (valor){
        _newPass2 = valor;
        if(_newPass2 == _newPass){
          _flagLenPass2 = true;
        } else {
          _flagLenPass2 = false;
        }
        setState(() {});
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: "Confirma Nueva Contraseña",
        suffixIcon: Icon(Icons.security)
      ),
    );
  }

  _botonEnviarNewPass(BuildContext context) {
    return RaisedButton(
      child: Text("Enviar Usuario"),
        onPressed: (!_flagLenPass2) ? null : (){
          print("Enviando nueva contraseña Usuario: ${widget.datos.usuario}");
          _responseAPI(context);
          // Navigator.pop(context);
        },
      );
  }

  Future<Null> _responseAPI(BuildContext context) async {
    final url = "http://192.168.1.106:5000/api/banco/usuarios/${widget.datos.idMongo}";
    final Map headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": widget.datos.headers
    };
    final bodySend = jsonEncode(<String, String>{
      "PASSWORD": "12345678"
    });
    print(url);
    final res = await http.patch(url, headers: headers, body: bodySend);
    final bodys = res.body;
    print(bodys);
    Navigator.pop(context);
  }
}