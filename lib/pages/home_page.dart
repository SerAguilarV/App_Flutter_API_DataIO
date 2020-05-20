import 'dart:async';
import 'dart:convert';

import 'package:api_node/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  static const String id = "/";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _usuario = "";
  bool _flag = true;
  bool _flagPass = true;
  bool _showCard = false;
  String _idBanco = "";
  String _idMongo = "";
  String _password = "";
  bool _flagText = true;
  bool _showCardNotFound = false;
  bool _showCardPassInvalid = false;
  NetworkImage _sexPersonURL;
  TextEditingController _controlTexto = new TextEditingController();
  TextEditingController _controlPass = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child:AppBar(
          title: Center(child: Text("Ingreso de usuario")),
          backgroundColor: Colors.redAccent,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: <Widget>[
            SizedBox(height: 80,),
            _getUser(),
            SizedBox(height: 10,),
            _getPass(),
            SizedBox(height: 50,),
            _botonSendAPI(context),
            SizedBox(height: 30,),
            _widgetresponseAPI(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.clear),
        backgroundColor: Colors.redAccent,
        onPressed: (){
          print("Floating Pressed!");
          setState(() {
            _usuario = "";
            _flag = true;
            _controlPass.clear();
            _controlTexto.clear();
            _showCard = false;
            _flagText = true;
            _showCardNotFound = false;
            _showCardPassInvalid = false;
          });
        }
      ),
    );
  }

  Widget _getUser() {
    return TextField(
      enabled: _flagText,
      controller: _controlPass,
      maxLength: 7,
      onChanged: (valor){
        bool valFlag = false;
        if(valor.length>=1){
          valFlag = false;
        }else{
          valFlag =true;
        }
        print("Usuario: " + valor);
        setState(() {
          _usuario=valor;
          _flag = valFlag;
        });
      },
      // keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: "Número de empleado",
        suffixIcon: Icon(Icons.account_circle)
      ),
    );
  }

  Widget _getPass() {
    return TextField(
      enabled: _flagText,
      controller: _controlTexto,
      obscureText: true,
      onChanged: (valor){
        bool valFlag = false;
        if(valor.length>=1){
          valFlag = false;
        }else{
          valFlag =true;
        }
        print("Contraseña: " + valor);
        setState(() {
          _password=valor;
          _flagPass = valFlag;
        });
      },
      // keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: "Contraseña",
        suffixIcon: Icon(Icons.security)
      ),
    );
  }

  Widget _botonSendAPI(BuildContext context) {
    return RaisedButton(
      child: Text("Enviar Usuario"),
        onPressed: (_flag || _flagPass) ? null : (){
          setState(() {
            // _flag = true;
            // _flagText = false;
          });
          print("Enviando Usuario: $_usuario");
          FocusScope.of(context).requestFocus(new FocusNode());
          _responseAPI(context);
        },
      );
  }

  Future<Null> _responseAPI(BuildContext context) async{
    final url = "http://192.168.1.106:5000/api/banco/usuarios/signin";
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(<String, String>{
      'username': _usuario,
      "password": _password
    });
    print(url);
    final res = await http.post(url,body: body, headers: headers);
    print(res.statusCode);
    final Map jsonP = json.decode(res.body);
    if (jsonP.containsKey("user") ) {
      final datos = Data(
          usuario: jsonP["user"]["username"],
          headers : jsonP["token"],
          idMongo: jsonP["user"]["id"]
        );
        Navigator.pushNamed(context, "/infoUser", arguments: datos);
    } else if(jsonP.containsKey("newPass")){
      if (jsonP["newPass"]){
        print("redirectionando");
        final datos = Data(
          usuario: jsonP["user"]["username"],
          headers : jsonP["token"],
          idMongo: jsonP["user"]["id"]
        );
        Navigator.pushNamed(context, "/newPass", arguments: datos);
      }
    }
    else if(res.statusCode == 400 && jsonP.containsKey("message")){
      if(jsonP["message"] == "Contraseña invalida"){
       setState(() {
        _showCard = false;
        _showCardPassInvalid = true;
      });
      }
    } else {
      setState(() {
        _showCard = false;
        _showCardNotFound = true;
      });
    }
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
            Text("ID Banco: $_idBanco"),
            Text('_id Mongo: $_idMongo'),
            SizedBox(height: 20,),
            Center(
              child: FadeInImage(placeholder: AssetImage("assets/loading.gif"), 
              image: _sexPersonURL,
              fadeInDuration: Duration(milliseconds: 200),
              height: 100,
              fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
    }
    else if(_showCardPassInvalid){
      return _cardGif('assets/wrong_pass.jpg', "Contraseña Invalida");
    }
    else if(_showCardNotFound){
      return _cardGif('assets/notfound.gif', "Usuario no encontrado");
    }
    else{
      return Divider();
    }
  }

  Widget _cardGif(String img, String textoCard) {
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
            Center(child: Text(textoCard)),
            SizedBox(height: 20,),
            Container(
              child: Center(child: Image(image: AssetImage(img),fit: BoxFit.cover,)),
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle
              ) ,
              ),
          ],
        ),
      ),
      );
  }

}
