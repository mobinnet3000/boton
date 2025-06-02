import 'package:boton/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Locale('fa'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Container(),
        appBar: AppBar(
          backgroundColor: Color(0xff27548A),
          title: Text("boton"),
          // leading: Icon(Icons.account_balance_rounded),
        ),
        body: ProjectListPage(),
      ),
    );
  }
}
