import 'package:boton/constants/mcolors.dart';
import 'package:boton/constants/text_style.dart';
import 'package:boton/data/fakedata.dart';
import 'package:boton/screens/home/each-project.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectsList extends StatelessWidget {
  const ProjectsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];

        return InkWell(
          onTap: () {
            Get.to(EachProlect());
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: firstdec,
            child: Row(
              children: [
                // بخش متنی
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project['projectNumber']!, style: projecttitle),
                      SizedBox(height: 8),
                      Text(
                        'کارفرما: ${project['employer']}',
                        style: projectsubtitle,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'آدرس: ${project['address']}',
                        style: projectsubtitle,
                      ),
                    ],
                  ),
                ),
                // فلش
                Icon(
                  Icons.arrow_forward_ios,
                  color: MyCollors.projjectsubtitlecolor,
                  size: 22,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
