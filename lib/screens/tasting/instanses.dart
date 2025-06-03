import 'package:boton/components/myybotton.dart';
import 'package:boton/components/responsivcont.dart';
import 'package:boton/components/textfield.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:boton/constants/text_style.dart';
import 'package:boton/screens/home/home.dart';
import 'package:boton/screens/tasting/tasting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstansesTesting extends StatefulWidget {
  InstansesTesting({super.key});

  @override
  State<InstansesTesting> createState() => _ChoiseFloatState();
}

class _ChoiseFloatState extends State<InstansesTesting> {
  List floats = ["نمونه شماره 1", "نمونه شماره 2", "نمونه شماره 3"];

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
                return mybotton(
                  ontap: () {
                    Get.to(EachTesting());
                  },
                  matn: floats[index],
                );
              },
            ),
          ),
          mybotton(
            ontap: () {
              Get.to(ProjectListPage());
            },
            matn: "ثبت نهایی",
          ),

          // mybotton(ontap: () {}, matn: 'نمونه جدید'),
        ],
      ),
    );
  }
}
