import 'package:api_node/pages/home_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getRoutes(){
  return {
    '/': (BuildContext context) => HomePage(),
  };
}