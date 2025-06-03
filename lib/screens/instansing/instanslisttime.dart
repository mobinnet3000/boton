import 'package:boton/components/myybotton.dart';
import 'package:boton/components/responsivcont.dart';
import 'package:boton/components/textfield.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:boton/constants/text_style.dart';
import 'package:boton/screens/instansing/instans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstanseTime extends StatefulWidget {
  @override
  _ProjectFormPageState createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<InstanseTime> {
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
              child: Text('فرم ثبت نمونه برداری', style: projecttitle),
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
                      MyTextFild(labeltext: " تاریخ نمونه برداری"),
                      MyTextFild(labeltext: " حجم نمونه برداری"),
                      MyTextFild(labeltext: " عیار سیمان"),
                      MyTextFild(labeltext: " رده ی بتنی"),
                      MyTextFild(labeltext: " وضعیت جوی"),
                      MyTextFild(labeltext: " نام کارخانه بتن"),
                    ],
                  ),
                ),
                mybotton(
                  ontap: () {
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
