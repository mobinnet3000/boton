import 'package:boton/components/myybotton.dart';
import 'package:boton/components/responsivcont.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:boton/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoqOrChak extends StatelessWidget {
  const MoqOrChak({super.key});

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
          mybotton(ontap: () {}, matn: 'مقاومت فشاری'),
          mybotton(
            ontap: () {
              Get.snackbar(
                'خطا',
                """
این مورد در بروزرسانی های آینده اضافه خواهد شد
از بروز بودن ورژن برنامه خود اطمینان حاصل فرمایید""",
                backgroundColor: const Color.fromARGB(125, 243, 57, 44),
              );
            },
            matn: 'چکش اسمیت',
          ),
        ],
      ),
    );
  }
}
