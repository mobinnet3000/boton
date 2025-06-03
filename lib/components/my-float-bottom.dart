import 'package:boton/constants/mcolors.dart';
import 'package:boton/screens/addproject/addproject.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MFloatBotton extends StatelessWidget {
  const MFloatBotton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Get.to(AddNewProject());
      },
      child: Icon(Icons.add, size: 40),
      isExtended: true,
      backgroundColor: MyCollors.prmrycolor,
      focusColor: MyCollors.floatbottmbghover,
      hoverColor: MyCollors.floatbottmbghover,
    );
  }
}
