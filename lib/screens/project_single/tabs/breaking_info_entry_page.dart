// lib/pages/project_single/tabs/breaking_info_entry_page.dart
import 'package:flutter/material.dart';

class BreakingInfoEntryPage extends StatelessWidget {
  final String seriesTitle;
  const BreakingInfoEntryPage({super.key, required this.seriesTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ورود اطلاعات شکست - $seriesTitle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('لطفاً اطلاعات نمونه را وارد کنید', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            TextFormField(decoration: const InputDecoration(labelText: 'جرم نمونه (گرم)')),
            const SizedBox(height: 16),
            TextFormField(decoration: const InputDecoration(labelText: 'بار گسیختگی (کیلوگرم)')),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () { /* TODO: منطق انتخاب عکس */ },
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('آپلود عکس نمونه شکسته شده'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // TODO: منطق ذخیره اطلاعات شکست
                Navigator.pop(context); // بازگشت به صفحه قبل
              },
              child: const Text('ثبت نهایی'),
            ),
          ],
        ),
      ),
    );
  }
}
