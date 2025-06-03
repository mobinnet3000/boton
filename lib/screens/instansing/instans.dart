import 'package:boton/components/myybotton.dart';
import 'package:boton/components/responsivcont.dart';
import 'package:boton/components/textfield.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:boton/constants/text_style.dart';
import 'package:boton/screens/home/home.dart';
import 'package:boton/screens/instansing/each-instanse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Instanses extends StatefulWidget {
  Instanses({super.key});

  @override
  State<Instanses> createState() => ChoiseFloatState();
}

class ChoiseFloatState extends State<Instanses> {
  RxList instt = ["نمونه 1", "نمونه 2"].obs;

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
              itemCount: instt.value.length,
              itemBuilder: (context, index) {
                return mybotton(
                  ontap: () {
                    // Get.to(EachInstanse());
                  },
                  matn: instt.value[index],
                );
              },
            ),
          ),

          mybotton(
            ontap: () {
              Get.to(EachInstanse());
            },
            matn: 'نمونه جدید',
          ),
          mybotton(
            ontap: () {
              Get.to(ProjectListPage());
            },
            matn: "ثبت نهایی",
          ),
        ],
      ),
    );
  }
}
