import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boton',
      theme: ThemeData(
        fontFamily: 'Vazir', // Updated fontFamily
        // Other theme properties
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boton', style: TextStyle(fontFamily: 'Vazir')), // Updated style
      ),
      body: Center(
        child: Text('Hello World!', style: TextStyle(fontFamily: 'Vazir')), // Updated style
      ),
    );
  }
}