import 'package:boton/controllers/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // برای فرمت کردن تاریخ

class BreakageView extends StatelessWidget {
  const BreakageView({super.key});

  @override
  Widget build(BuildContext context) {
    // کنترلر را پیدا کن (چون قبلا در HomeView با Get.put ساخته شده)
    final ProjectController controller = Get.put(ProjectController());

    return Scaffold(
      appBar: AppBar(title: const Text('لیست شکست قالب‌ها')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.breakageGroups.isEmpty) {
          return const Center(
            child: Text('هیچ قالبی برای شکست در آینده نزدیک وجود ندارد.'),
          );
        }

        return ListView.builder(
          itemCount: controller.breakageGroups.length,
          itemBuilder: (context, index) {
            final group = controller.breakageGroups[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.projectName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          // نمایش تاریخ به فرمت خوانا
                          DateFormat('yyyy/MM/dd').format(group.deadline),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${group.molds.length} قالب آماده شکست',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
