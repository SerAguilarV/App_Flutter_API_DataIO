import 'package:api_node/pages/NewPass.dart';
import 'package:api_node/pages/buscar_page.dart';
import 'package:api_node/pages/editar_page.dart';
import 'package:api_node/pages/home_page.dart';
import 'package:api_node/pages/infoUsuarios_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Response API-Node.js",
        initialRoute: HomePage.id,
        onGenerateRoute: (settings){
          if(settings.name == NewPass.id){
            return MaterialPageRoute(builder: (_) => NewPass(settings.arguments));
          } else if(settings.name == InfoUserPage.id){
            return MaterialPageRoute(builder: (_) => InfoUserPage(settings.arguments));
          } else if(settings.name == BuscarPage.id){
            return MaterialPageRoute(builder: (_) => BuscarPage(settings.arguments));
          } else if(settings.name == EditPage.id){
            return MaterialPageRoute(builder: (_) => EditPage(settings.arguments));
          } else {
            return MaterialPageRoute(builder: (_) => HomePage());
          }
        },
        // routes: getRoutes(),
      );
  }
}