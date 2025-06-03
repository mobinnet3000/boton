import 'package:boton/components/myybotton.dart';
import 'package:boton/components/responsivcont.dart';
import 'package:boton/components/textfield.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:boton/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Instanses extends StatefulWidget {
  Instanses({super.key});

  @override
  State<Instanses> createState() => _ChoiseFloatState();
}

class _ChoiseFloatState extends State<Instanses> {
  List floats = [];

  @override
  Widget build(BuildContext context) {
    return RespCont(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: MyPadings.large,
            child: Text('ثبت نمونه جدید', style: largtitletext),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: floats.length,
              itemBuilder: (context, index) {
                return mybotton(ontap: () {}, matn: floats[index]);
              },
            ),
          ),

          mybotton(ontap: () {}, matn: 'نمونه جدید'),
        ],
      ),
    );
  }
}
