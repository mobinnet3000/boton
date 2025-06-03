import 'package:boton/constants/mcolors.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle projecttitle = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: MyCollors.prmrycolor,
);
TextStyle projectsubtitle = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: MyCollors.projjectsubtitlecolor,
);

BoxDecoration firstdec = BoxDecoration(
  color: MyCollors.firstcolor,
  borderRadius: BorderRadius.circular(20),
  boxShadow: [MyShados.projectsshadow],
);

BoxDecoration titledec = BoxDecoration(
  color: MyCollors.firstcolor,
  borderRadius: BorderRadius.circular(8),
  boxShadow: [MyShados.projectsshadow],
);
