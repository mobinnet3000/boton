import 'package:boton/constants/mcolors.dart';
import 'package:boton/screens/addproject/addproject.dart';
import 'package:boton/screens/home/each-project.dart';
import 'package:boton/screens/home/home.dart';
import 'package:boton/screens/instansing/bot-or-mill.dart';
import 'package:boton/screens/instansing/chose-float.dart';
import 'package:boton/screens/instansing/each-instanse.dart';
import 'package:boton/screens/instansing/instans.dart';
import 'package:boton/screens/instansing/instanslisttime.dart';
import 'package:boton/screens/tasting/instanses.dart';
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
          backgroundColor: MyCollors.appbarcolor,
          title: Text("boton"),
          // leading: Icon(Icons.account_balance_rounded),
        ),
        body: ProjectListPage(),
      ),
    );
  }
}
