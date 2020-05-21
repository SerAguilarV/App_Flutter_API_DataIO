import 'package:api_node/utils/data.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  EditPage(this.datos);
  final Data datos;
  static final String id = "/edit";
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modificar datos de ${widget.datos.usuario}"),
        backgroundColor: Colors.redAccent,
      ),
       body: _camposEditar(),

    );
  }

  Widget _camposEditar() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _getFields(),
    );
  }

  List<Widget> _getFields() {
    final List<Widget> listaWidgets = [];
    listaWidgets.add(Container(
      alignment: Alignment.center,
      child: RaisedButton(
        color: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        onPressed: (){
        },
        child: Text("Actualizar", style: TextStyle(color: Colors.white),),
      ),
    ));
    return  listaWidgets;
  }
}