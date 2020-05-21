import 'package:api_node/utils/data.dart';
import 'package:flutter/material.dart';

class BuscarPage extends StatefulWidget {
  BuscarPage(this.datos);
  final Data datos;
  static final String id = "/search";
  @override
  _BuscarPageState createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  String _strSearch = "";
  bool _flagBoton = false;
  bool _morePage = false;
  bool _lessPage = false;
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
          // _listaresultados(),
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
              if(value.length ==0){
                _flagBoton = false;
              } else {
                _flagBoton = true;
              }
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
          onPressed: (){
            print("Buscar");
          }
        ),
      ],
    );
  }

  Widget _widgetListaResultados() {
    return ListView(
      children: <Widget>[],
    );
  }
}