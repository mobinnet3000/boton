import 'package:boton/components/myybotton.dart';
import 'package:boton/components/responsivcont.dart';
import 'package:boton/components/textfield.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:boton/constants/text_style.dart';
import 'package:boton/screens/home/home.dart';
import 'package:boton/screens/instansing/bot-or-mill.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNewProject extends StatefulWidget {
  @override
  _ProjectFormPageState createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<AddNewProject> {
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
              child: Text('فرم ثبت پروژه جدید', style: projecttitle),
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
                      MyTextFild(labeltext: "شماره پرونده"),
                      MyTextFild(labeltext: "نام کارفرما"),
                      MyTextFild(labeltext: "آدرس", maxlins: 3),
                      MyTextFild(labeltext: "پلاک ثبتی"),
                      MyTextFild(labeltext: "کاربری پروژه"),
                      MyTextFild(labeltext: "منطقه شهرداری"),
                      MyTextFild(labeltext: "زیربنا یا سطح اشغال"),
                      MyTextFild(labeltext: "تعداد سقف"),
                      MyTextFild(labeltext: "تیپ سیمان"),
                      MyTextFild(labeltext: "قالب نمونه برداری"),
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
                        matn: 'ثبت و ادامه نمونه گیری',
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: mybotton(
                        ontap: () {
                          Get.to(ProjectListPage());
                        },
                        matn: 'ثبت و پایان',
                      ),
                    ),
                  ],
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
