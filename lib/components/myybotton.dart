import 'package:boton/constants/mypaddings.dart';
import 'package:boton/constants/text_style.dart';
import 'package:flutter/material.dart';

class mybotton extends StatelessWidget {
  mybotton({super.key, required this.ontap, required this.matn});
  final void Function()? ontap;
  final String matn;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyPadings.normal,
      child: InkWell(
        onTap: ontap,
        child: Container(
          // width: double.infinity,
          decoration: titledec,
          child: Padding(
            padding: MyPadings.normal,
            child: Center(child: Text(matn, style: projecttitle)),
          ),
        ),
      ),
    );
  }
}
