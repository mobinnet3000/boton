import 'package:boton/constants/mcolors.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:flutter/material.dart';

class MyTextFild extends StatelessWidget {
  MyTextFild({
    super.key,
    required this.labeltext,
    this.cont,
    this.maxlins,
    this.readonly,
  });
  final String labeltext;
  bool? readonly = false;
  int? maxlins = 1;
  TextEditingController? cont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyPadings.normal,
      child: TextFormField(
        readOnly: readonly!,
        maxLines: maxlins,
        controller: cont,
        validator:
            (value) => value!.isEmpty ? 'لطفاً این فیلد را تکمیل کنید' : null,

        onSaved: (newValue) {},
        decoration: InputDecoration(
          labelText: labeltext,

          labelStyle: TextStyle(
            color: MyCollors.firstcolor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          filled: true,
          fillColor: MyCollors.prmrycolor,
          prefixIcon: Icon(Icons.assignment, color: MyCollors.firstcolor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: MyCollors.firstcolor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: MyCollors.firstcolor, width: 2.5),
          ),
        ),
        style: TextStyle(
          color: MyCollors.firstcolor,

          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
