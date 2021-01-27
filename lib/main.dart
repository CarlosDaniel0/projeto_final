import 'package:flutter/material.dart';
import 'views/loginPage.dart';
import 'views/home.dart';
import 'views/mapas.dart';
import 'views/contatos.dart';
void main() {
  runApp(MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.green[600],
          visualDensity: VisualDensity.adaptivePlatformDensity),
      title: 'Projeto Final',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => Home(),
        '/home/contatos': (context) => Contatos(),
        '/home/mapa': (context) => Mapas()
      }));
}
