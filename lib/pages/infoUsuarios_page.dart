import 'dart:convert';

import 'package:api_node/utils/data.dart';
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;

class InfoUserPage extends StatefulWidget {
  final Data datos;
  InfoUserPage(this.datos);
  static const String id = "/infoUser";
  @override
  _InfoUserPageState createState() => _InfoUserPageState();
}

class _InfoUserPageState extends State<InfoUserPage> {
  Map _jsonP;
  bool _ready = false;
  TextStyle _estilo = TextStyle(fontSize:15, fontWeight: FontWeight.bold);
  String _img;

  @override
  void initState() {
    super.initState();
    _getDatosUsuarios(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          alignment: Alignment.bottomRight,
          child: AppBar(
          title: Text("Banco S: Bienvenido",),
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right:  10, top: 5),
              child: _avatarGenero()
              ),
          ],),
        )),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: _menuLista(),
        // 
        // _listaMenu(),
      ),
    );
  }

  Future<Null> _getDatosUsuarios(BuildContext context) async{
    final url = "http://192.168.1.106:5000/api/banco/usuarios/${widget.datos.idMongo}/info";
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": widget.datos.headers
    };
    final res = await http.get(url, headers: headers);
    _jsonP = json.decode(res.body);
    if (res.statusCode == 200) {
      _jsonP["FECHA_INGRESO"] = DateTime.parse(_jsonP["FECHA_INGRESO"]);
      _jsonP["FECHA_INGRESO"] = '${_jsonP["FECHA_INGRESO"].day}/${_jsonP["FECHA_INGRESO"].month}/${_jsonP["FECHA_INGRESO"].year}';
      _showWidgets();
    } else {
        Navigator.pop(context);
    }
  }

  void _showWidgets() {
    setState(() {
      _ready = true;
    });
  }

  Widget _datosUsuario() {
    if(_ready){
    return Container(
      alignment: Alignment.center,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 20,
        child: Container(
          width: 350,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("ID Banco: ${_jsonP["ID"]}",style: _estilo ),
              Text('Nombre: ${_jsonP["Datos"]["NOMBRE"]} ${_jsonP["Datos"]["APELLIDOS"]}', style: _estilo),
              Text('Nivel: ${_jsonP["NIVEL"]}',style: _estilo),
              Text('Sueldo: \$${_jsonP["SUELDO"]}',style: _estilo),
              Text('Fecha de Ingreso: ${_jsonP["FECHA_INGRESO"]}',style: _estilo),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
    }else{
      return Divider();
    }
  }

  Widget _avatarGenero() {
    if(_ready){
      if(_jsonP["Datos"]["GENERO"] == "H"){
        _img = "assets/icono_H.png";
      }else{
        _img = "assets/icono_M.png";
      }
      return CircleAvatar(
        backgroundImage: AssetImage(_img),
      );
  } else{
    return Icon(Icons.account_circle);
  }
  }

  List<Widget>_menuLista() {
    final List<Widget> op = [];
    op..add(SizedBox(height: 20,))
    ..add(_datosUsuario(),)
    ..add(SizedBox(height: 50,))
    ..add(Container(
      width: 300,
      color: Colors.redAccent,
      child: ListTile(
          title: Text("Buscar en la base de empleados", style: TextStyle(color: Colors.white),),
          trailing: Icon(Icons.search, color: Colors.white,),
          onTap: (){
            Navigator.pushNamed(context, "/search", arguments: widget.datos);
          },
          ),
    ),)
    ..add(SizedBox(height: 20,))
    ..add(Container(
      width: 300,
      color: Colors.redAccent,
      child: ListTile(
          title: Text("Editar informacion", style: TextStyle(color: Colors.white),),
          trailing: Icon(Icons.edit, color: Colors.white,),
          onTap: (){
            Navigator.pushNamed(context, "/edit", arguments: widget.datos);
          },
          ),
    ),);
    return op;
  }

}