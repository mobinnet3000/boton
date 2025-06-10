// lib/pages/project_single/tabs/add_sample_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// بخش اطلاعات شکست از اینجا حذف شد

class AddSamplePage extends StatelessWidget {
  final String sectionName;
  final int nextSampleNumber;

  const AddSamplePage({
    super.key,
    required this.sectionName,
    required this.nextSampleNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('افزودن نمونه ${nextSampleNumber} - $sectionName'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('اطلاعات نمونه برداری', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            
            TextFormField(decoration: const InputDecoration(labelText: 'تاریخ نمونه‌گیری')),
            const SizedBox(height: 16),
            TextFormField(decoration: const InputDecoration(labelText: 'حجم بتن‌ریزی (متر مکعب)')),
            const SizedBox(height: 16),
            TextFormField(decoration: const InputDecoration(labelText: 'عیار سیمان')),
            const SizedBox(height: 16),
            TextFormField(decoration: const InputDecoration(labelText: 'رده بتن')),
            const SizedBox(height: 16),
            TextFormField(decoration: const InputDecoration(labelText: 'وضعیت جوی')),
            const SizedBox(height: 16),
            TextFormField(decoration: const InputDecoration(labelText: 'نام کارخانه بتن')),
            const SizedBox(height: 40),

            // *** بخش ExpansionTile اطلاعات شکست از اینجا حذف شد ***

            ElevatedButton.icon(
              onPressed: () {
                // TODO: منطق ذخیره نمونه جدید در دیتابیس
                Get.back(); // بازگشت به لیست نمونه‌ها
              },
              icon: const Icon(Icons.save),
              label: const Text('ثبت و افزودن نمونه'),
            )
          ],
        ),
      ),
    );
  }
}
