import 'package:boton/components/myybotton.dart';
import 'package:boton/components/responsivcont.dart';
import 'package:boton/components/textfield.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:boton/constants/text_style.dart';
import 'package:boton/screens/instansing/bot-or-mill.dart';
import 'package:boton/screens/tasting/what-day.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EachProlect extends StatefulWidget {
  @override
  _ProjectFormPageState createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<EachProlect> {
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
              child: Text('فلان پروژه', style: projecttitle),
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
                      MyTextFild(readonly: true, labeltext: "شماره پرونده"),
                      MyTextFild(readonly: true, labeltext: "نام کارفرما"),
                      MyTextFild(readonly: true, labeltext: "آدرس", maxlins: 3),
                      MyTextFild(readonly: true, labeltext: "پلاک ثبتی"),
                      MyTextFild(readonly: true, labeltext: "کاربری پروژه"),
                      MyTextFild(readonly: true, labeltext: "منطقه شهرداری"),
                      MyTextFild(
                        readonly: true,
                        labeltext: "زیربنا یا سطح اشغال",
                      ),
                      MyTextFild(readonly: true, labeltext: "تعداد سقف"),
                      MyTextFild(readonly: true, labeltext: "تیپ سیمان"),
                      MyTextFild(
                        readonly: true,
                        labeltext: "قالب نمونه برداری",
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: mybotton(
                        ontap: () {
                          Get.to(BotOrMill());
                        },
                        matn: 'ثبت نمونه گیری ',
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: mybotton(
                        ontap: () {
                          Get.to(WhatDay());
                        },
                        matn: "ثبت اطلاعات شکست ",
                      ),
                    ),
                  ],
                ),
                mybotton(ontap: () {}, matn: "تغییر اطلاعات"),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
