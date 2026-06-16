import 'package:flutter/material.dart';
import 'package:sa_somativa_encomendas/views/home_screen.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: "Registro de Encomendas",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: HomeScreen(),
  ));
}