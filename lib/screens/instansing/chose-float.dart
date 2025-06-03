import 'package:boton/components/myybotton.dart';
import 'package:boton/components/responsivcont.dart';
import 'package:boton/components/textfield.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:boton/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoiseFloat extends StatefulWidget {
  ChoiseFloat({super.key});

  @override
  State<ChoiseFloat> createState() => _ChoiseFloatState();
}

class _ChoiseFloatState extends State<ChoiseFloat> {
  List floats = ['فنداسیون', 'ستون اول', 'سقف اول'];

  TextEditingController cont1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return RespCont(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: MyPadings.large,
            child: Text("ثبت اطلاعات نمونه برداری", style: largtitletext),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: floats.length,
              itemBuilder: (context, index) {
                return mybotton(ontap: () {}, matn: floats[index]);
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: MyTextFild(labeltext: 'افزودن', cont: cont1),
              ),
              Expanded(
                flex: 1,
                child: mybotton(
                  ontap: () {
                    setState(() {
                      floats.add(cont1.value.text.toString());
                      cont1.clear();
                    });
                  },
                  matn: 'تایید',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
