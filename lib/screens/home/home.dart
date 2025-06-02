import 'package:boton/components/my-float-bottom.dart';
import 'package:boton/components/mysearchbar.dart';
import 'package:boton/components/projectslist.dart';
import 'package:boton/components/responsivcont.dart';
import 'package:boton/constants/mypaddings.dart';
import 'package:flutter/material.dart';

class ProjectListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MFloatBotton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: RespCont(
        child: Column(
          children: [
            Padding(padding: MyPadings.large, child: MySearchbar()),
            Expanded(child: ProjectsList()),
          ],
        ),
      ),
    );
  }
}
