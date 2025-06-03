import 'package:boton/components/myybotton.dart';
import 'package:boton/components/responsivcont.dart';
import 'package:boton/components/textfield.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:boton/constants/text_style.dart';
import 'package:flutter/material.dart';

class EachTesting extends StatefulWidget {
  @override
  _ProjectFormPageState createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<EachTesting> {
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
              child: Text('ثبت اطلاعات شکست', style: projecttitle),
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
                      MyTextFild(labeltext: "جرم نمونه"),
                      MyTextFild(labeltext: "بازگسیختگی"),
                      MyTextFild(labeltext: "ثبت عکس و فیلم"),
                    ],
                  ),
                ),
                mybotton(ontap: () {}, matn: 'ثبت اطلاعات'),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
