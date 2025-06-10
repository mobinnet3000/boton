import 'package:boton/constants/mcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MFloatBotton extends StatelessWidget {
  const MFloatBotton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Get.to();
      },
      isExtended: true,
      backgroundColor: MyCollors.prmrycolor,
      focusColor: MyCollors.floatbottmbghover,
      hoverColor: MyCollors.floatbottmbghover,
      child: Icon(Icons.add, size: 40),
    );
  }
}
