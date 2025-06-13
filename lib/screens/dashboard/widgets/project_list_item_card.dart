// lib/pages/dashboard/widgets/project_list_item_card.dart
import 'package:boton/models/project_model.dart';
import 'package:boton/screens/project_single/project_single_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boton/models/project.dart';

class ProjectListItemCard extends StatelessWidget {
  final Project project;
  final VoidCallback onDelete;

  const ProjectListItemCard({
    super.key,
    required this.project,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1.0),
      ),
      color: Colors.white, // رنگ صریح سفید برای کارت
      child: InkWell(
        onTap:
            () => Get.to(
              () => ProjectSinglePage(project: project),
              transition: Transition.rightToLeftWithFade,
            ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.foundation,
                    color: Theme.of(context).primaryColor,
                    size: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.projectName,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'کارفرما: ${project.clientName}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(project.fileNumber),
                    backgroundColor: Colors.blue.shade50,
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      Icons.engineering_outlined,
                      project.supervisorName,
                    ),
                  ),
                  SizedBox(width: 8.0), // برای ایجاد فاصله بین آیتم‌ها
                  Expanded(
                    child: _buildInfoChip(
                      Icons.layers_outlined,
                      '${project.floorCount} طبقه',
                    ),
                  ),
                  SizedBox(width: 8.0), // برای ایجاد فاصله بین آیتم‌ها
                  Expanded(
                    child: _buildInfoChip(
                      Icons.location_city_outlined,
                      'منطقه ${project.municipalityZone}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.black54),
      label: Text(text, style: const TextStyle(color: Colors.black54)),
      backgroundColor: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
