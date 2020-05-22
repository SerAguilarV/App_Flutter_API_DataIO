import 'dart:convert';

import 'package:api_node/utils/data.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class BuscarPage extends StatefulWidget {
  BuscarPage(this.datos);
  final Data datos;
  static final String id = "/search";
  @override
  _BuscarPageState createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  String _strSearch = "";
  String _showText = "";
  Map _jsonP;
  int _pagina = 1;
  int _minUs;
  int  _maxUs;
  bool _showList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar empleados", style:TextStyle(color:Colors.white),),
        backgroundColor: Colors.redAccent,
      ),
       body: _camposEditar(),

    );
  }

  Widget _camposEditar() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
          SizedBox(height: 20,),
          _widgetBuscar(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15) ,
            child: Divider(height: 20,color: Colors.redAccent, thickness: 0.5,)
          ),
          _textoResultados(),
          Container(
            height: 500,
            child: ListView(
              children: _listaresultados(),
            ),
          ),
          // _botonesPagina()
      ],
    );
  }

  Widget _widgetBuscar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width - 150,
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              hintText: "Search ...",
            ),
            onChanged: (value){
              setState(() {
                _strSearch = value;
                print("String a Buscar: $_strSearch");
              });
            },
          ),
        ),
        RaisedButton(
          color: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text("Buscar", style: TextStyle(color: Colors.white),),
          onPressed: (_strSearch.length == 0)? null : (){
            print("Buscar: $_strSearch");
            FocusScope.of(context).requestFocus(new FocusNode());
            _pagina = 1;
            _buscar();
          }
        ),
      ],
    );
  }

  Future _buscar() async{
    final url = "http://192.168.1.106:5000/api/banco/usuarios/search?cadena=$_strSearch&page=$_pagina";
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": widget.datos.headers
    };
    final res = await http.get(url, headers: headers);
    print(res.statusCode);
    _jsonP = json.decode(res.body);
    print(_jsonP);
    _minUs = (_pagina - 1)  * 5 + 1;
    _maxUs = (_pagina - 1)  * 5 + 5;
    if( _maxUs >= _jsonP["Total"]){
      _maxUs = _jsonP["Total"];
    }
    if(res.statusCode == 200){
      _showText = "Se encontraron ${_jsonP["Total"]} resultados ($_minUs - $_maxUs)";
      _showList = true;
    } else{
      _showText = "Error en el server ... :c";
      _showList = false;
    }
    setState(() {});
  }

  Widget _textoResultados() {
    if(_showText != ""){
      return Container(
        height: 40,
        width: MediaQuery.of(context).size.width - 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.redAccent
          ),
        child: Text(_showText, style: TextStyle(color: Colors.white),),
      );
    } else {
      return SizedBox(height: 5,);
    }
  }

  List<Widget>_listaresultados() {
    if(_showList){ 
      List<Widget> lista = [];
      lista.add(Divider(height: 3, color: Colors.white,));
      _jsonP["Usuarios"].forEach((key) {
        String img;
        if(key["Datos"]["GENERO"] == "H"){
          img = "assets/icono_H.png";
        }else{
          img = "assets/icono_M.png";
        }
        final nombre = key["Datos"]["NOMBRE"] + " " + key["Datos"]["APELLIDOS"];
        final Card carta = Card(
          color: Colors.redAccent,
          elevation: 8,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 80,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal : 25.0),
                      child: Text("ID : ${key['ID']}", style: TextStyle(color: Colors.white),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text("Nombre : $nombre", style: TextStyle(color: Colors.white),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text("Nivel : ${key['NIVEL']}", style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                // color: Colors.black,
                child: CircleAvatar(backgroundImage: AssetImage(img),),
                // width: 50,
              ),
            ],
          ),
        );
        lista.add(Container(
          child: carta,
          padding: EdgeInsets.all(2),
          height: 80,
          width: MediaQuery.of(context).size.width - 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ));
        lista.add(Divider(height: 1, color: Colors.white,));
      });
      lista.add(_flechas());
      return lista;
    }
    else{
      List<Widget> lista = [];
      lista.add(Divider());
      // lista.add(Text("Mundo"));
      return lista;
    }
  }

  Widget _flechas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        RaisedButton(
          color: Colors.redAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Icon(Icons.first_page),
          onPressed: (_minUs != 1)? (){
            _pagina = _pagina - 1;
            setState(() {});
            _buscar();
          } : null
        ),
        SizedBox(width: 20,),
        RaisedButton(
          color: Colors.redAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Icon(Icons.last_page),
          onPressed: (_maxUs < _jsonP["Total"])? (){
            _pagina = _pagina + 1;
            setState(() {});
            _buscar();
          } : null
        ),
      ],
    );
  }
}