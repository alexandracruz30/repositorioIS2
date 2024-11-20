import 'package:flutter/material.dart'; //importo todo los Widget que voy a usar
import 'package:healthyfoodscan/homepage.dart';

void main() => runApp(const MyApp()); //ejecuta el widget

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  //constructor
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Healthy Food Scan', //nombre de la app
      home: HomePage(),
    );
  }
}
