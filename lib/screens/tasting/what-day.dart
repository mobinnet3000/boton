import 'package:boton/components/myybotton.dart';
import 'package:boton/components/responsivcont.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:boton/constants/text_style.dart';
import 'package:boton/screens/tasting/instanses.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhatDay extends StatelessWidget {
  const WhatDay({super.key});

  @override
  Widget build(BuildContext context) {
    return RespCont(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: MyPadings.large,
            child: Text(
              'لطفا یکی از موارد زیر را انتخاب کنید',
              style: largtitletext,
            ),
          ),
          mybotton(
            ontap: () {
              Get.to(InstansesTesting());
            },
            matn: 'شکست 7 روزه',
          ),
          mybotton(
            ontap: () {
              Get.to(InstansesTesting());
            },
            matn: 'شکست 28 روزه',
          ),
          mybotton(
            ontap: () {
              Get.to(InstansesTesting());
            },
            matn: 'شکست 90 روزه',
          ),
        ],
      ),
    );
  }
}
