import 'package:boton/constants/mcolors.dart';
import 'package:flutter/material.dart';

class MySearchbar extends StatelessWidget {
  const MySearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      backgroundColor: WidgetStateProperty.all(MyCollors.prmrycolor),
      hintText: "جستوجو",
      leading: Icon(Icons.search),
    );
  }
}
