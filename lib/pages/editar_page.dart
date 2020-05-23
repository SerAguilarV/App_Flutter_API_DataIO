import 'dart:convert';

import 'package:api_node/utils/data.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class EditPage extends StatefulWidget {
  EditPage(this.datos);
  final Data datos;
  static final String id = "/edit";
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Map<String,Map<String,dynamic>> _campos = {
    // "Nombre": {"Icono" : Icon(Icons.account_circle), "keyboard" : TextInputType.text, "data" : "", "json" : "NOMBRE"},
    // "Apellidos": {"Icono": Icon(Icons.account_circle), "keyboard" : TextInputType.text, "data" : ""},
    "Nivel" : {"Icono": Icon(Icons.assessment), "keyboard" : TextInputType.number, "data" : "", "json" :"NIVEL"},
    "Sueldo" : {"Icono": Icon(Icons.monetization_on),  "keyboard" : TextInputType.number, "data" : "", "json" :"SUELDO"},
    "Fecha de Ingreso": {"Icono": Icon(Icons.date_range),  "keyboard" : TextInputType.datetime, "data" : "", "json" :"FECHA_INGRESO"},
    "Contraseña": {"Icono": Icon(Icons.lock_outline), "keyboard" : TextInputType.text, "data" : "", "json" :"PASSWORD"},
  };
  // List<String> _campos = ["Nombre", "Apellidos", "Nivel", "Sueldo", "Fecha de Ingreso"];
  final Map _jsonEnviar = {};
  String _fecha;
  TextEditingController _inputField = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modificar datos de ${widget.datos.usuario}"),
        backgroundColor: Colors.redAccent,
      ),
       body: _camposEditar(context),
      //  floatingActionButton:
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _camposEditar(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          // alignment: Alignment.center,
          // width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: _getFields(),
            ),
        ),
      ],
    );
  }

  List<Widget> _getFields() {
    final List<Widget> listaWidgets = [];
    _campos.forEach((key, datos) {
      if(key=="Fecha de Ingreso"){
        listaWidgets.add( _crearFecha(context, datos));
      } else {
      final textField = new TextField(
        obscureText: (key == "Contraseña")? true:false,
        keyboardType: datos["keyboard"],
        onChanged: (value){datos["data"] = value;},
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: key,
          suffixIcon: datos["Icono"],
        ),
      );
      listaWidgets.add(textField);
      }
    listaWidgets.add(SizedBox(height: 8,));
    });
    listaWidgets.add(RaisedButton(
          color: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          onPressed: (){
            _campos.forEach((key, datos) {
              // print("$key : ${datos["data"]}");
              if(datos["data"] != ""){
                if(key == "Nivel" || key == "Sueldo"){
                  _jsonEnviar[datos["json"]] = int.parse(datos["data"]);
                } else {
                  _jsonEnviar[datos["json"]] = datos["data"];
                }
              }
            });
            print(_jsonEnviar);
            _actualizarDatos();
          },
          child: Text("Actualizar", style: TextStyle(color: Colors.white),),
      ),);
    return  listaWidgets;
  }

   Widget _crearFecha(BuildContext context, datos) {
    return TextField(
      controller: _inputField,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: "Fecha de Ingreso",
        // labelText: 'Fecha de Nacimiento',
        suffixIcon: Icon(Icons.date_range),
      ),
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context, datos);
      },
    );
  }

  void _selectDate(BuildContext context, datos) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1950),
      lastDate: DateTime.now(),
      // locale: Locale('es', 'MX'),
    );
    if (picked != null){
      setState(() {
        _fecha = "${picked.day.toString()}/${picked.month.toString()}/${picked.year.toString()}";
        _inputField.text = _fecha;
        datos["data"] = picked;
    });
  }
  }

  Future<Null> _actualizarDatos() async {
    final url = "http://192.168.1.106:5000/api/banco/usuarios/${widget.datos.idMongo}";
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": widget.datos.headers
    };
    final res = await http.patch(url,body: jsonEncode(_jsonEnviar), headers: headers);
    if(res.statusCode == 200){
      print("Actualizado :)");
      Navigator.pop(context);
    } else {
      print("No actualizado :(");
    }
  }

}