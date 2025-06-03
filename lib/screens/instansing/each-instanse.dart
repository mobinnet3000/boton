import 'package:boton/components/myybotton.dart';
import 'package:boton/components/responsivcont.dart';
import 'package:boton/components/textfield.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:boton/constants/text_style.dart';
import 'package:boton/screens/instansing/instans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EachInstanse extends StatefulWidget {
  @override
  _ProjectFormPageState createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<EachInstanse> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            decoration: titledec,
            child: Padding(
              padding: MyPadings.normal,
              child: Text('ثبت سری نمونه جدید', style: projecttitle),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RespCont(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      MyTextFild(labeltext: "دمای محیط"),
                      MyTextFild(labeltext: "بتن"),
                      MyTextFild(labeltext: "اسلاچپ"),
                      MyTextFild(labeltext: "محدوده نمونه برداری"),
                      MyTextFild(labeltext: "درصد هوای بتن"),
                      MyTextFild(labeltext: "مواد افزودنی"),
                      MyTextFild(labeltext: "مستندات"),
                    ],
                  ),
                ),
                mybotton(
                  ontap: () {
                    ChoiseFloatState().instt.add("value");

                    Get.to(Instanses());
                  },
                  matn: 'ثبت اطلاعات',
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
