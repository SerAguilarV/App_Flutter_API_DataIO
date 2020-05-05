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
  String _apellidos = "";
  String _id = "";
  bool _flagText = true;
  bool _showCardNotFound = false;
  String _fechaingreso = "" ;
  NetworkImage _sexPersonURL;
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
            _showCardNotFound = false;
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
      // keyboardType: TextInputType.number,
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
    final url = "https://api-banco-test.herokuapp.com/api/banco/usuarios/$_usuario/IDBanco";
    print(url);
    final res = await http.get(url);
    print(res.statusCode);
    final Map jsonP = json.decode(res.body);
    if (jsonP.containsKey("ID") ) {
      setState(() {
        _nombre = jsonP["Datos"]["NOMBRE"];
        _apellidos = jsonP["Datos"]["APELLIDOS"];
        _id = jsonP["ID"];
        _fechaingreso = jsonP["FECHA_INGRESO"];
        _showCard = true;
        _showCardNotFound = false;
        if (jsonP["Datos"]["GENERO"] == "M") {
          _sexPersonURL = NetworkImage("https://f0.pngfuel.com/png/168/827/female-icon-illustration-png-clip-art.png");
        } else {
          _sexPersonURL = NetworkImage("https://www.kindpng.com/picc/m/21-211180_transparent-businessman-clipart-png-user-man-icon-png.png");
        }
      });
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
            Text("ID: $_id"),
            Text('Nombre: $_nombre'),
            Text("Apellidos: $_apellidos"),
            Text("Fecha de Ingreso: $_fechaingreso"),
            SizedBox(height: 20,),
            Center(
              child: FadeInImage(placeholder: AssetImage("assets/loading.gif"), 
              image: _sexPersonURL,
              fadeInDuration: Duration(milliseconds: 200),
              height: 200,
              fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
    }
    else if(_showCardNotFound){
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
            Center(child: Text("Usuario no encontrado")),
            SizedBox(height: 20,),
            Container(
              child: Center(child: Image(image: AssetImage('assets/notfound.gif'),fit: BoxFit.cover,)),
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
    else{
      return Text("");
    }
  }
}