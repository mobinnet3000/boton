import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RespCont extends StatelessWidget {
  RespCont({super.key, required this.child});
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 1000),
        child: child,
      ),
    );
  }
}
