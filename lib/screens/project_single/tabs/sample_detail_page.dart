// lib/pages/project_single/tabs/sample_detail_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boton/models/concrete_sample_model.dart';
import 'package:boton/screens/project_single/widgets/info_display_field.dart';
import 'breaking_info_entry_page.dart';

class SampleDetailPage extends StatefulWidget {
  final ConcreteSample sample;
  final String sectionName;

  const SampleDetailPage({
    super.key,
    required this.sample,
    required this.sectionName,
  });

  @override
  State<SampleDetailPage> createState() => _SampleDetailPageState();
}

class _SampleDetailPageState extends State<SampleDetailPage> {
  bool _isEditingSamplingInfo = false; // وضعیت قفل/ویرایش

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('جزئیات نمونه ${widget.sample.sampleNumber} - ${widget.sectionName}'),
      ),
      // دکمه شناور برای تغییر وضعیت ویرایش/ذخیره
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _isEditingSamplingInfo = !_isEditingSamplingInfo),
        label: Text(_isEditingSamplingInfo ? 'ذخیره اطلاعات' : 'تغییر اطلاعات نمونه‌برداری'),
        icon: Icon(_isEditingSamplingInfo ? Icons.save : Icons.edit),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // پدینگ برای دکمه شناور
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بخش ۱: نمایش اطلاعات نمونه‌برداری (قفل شده یا قابل ویرایش)
            Text('اطلاعات نمونه‌برداری', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _isEditingSamplingInfo ? _buildEditSamplingForm() : _buildDisplaySamplingInfo(),
            
            const Divider(height: 40, thickness: 1),

            // بخش ۲: ثبت اطلاعات شکست
            Text('ثبت نتایج شکست', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ListTile(title: const Text('سری ۷ روزه'), trailing: const Icon(Icons.add), onTap: () => Get.to(() => const BreakingInfoEntryPage(seriesTitle: 'سری ۷ روزه'))),
            ListTile(title: const Text('سری ۲۸ روزه'), trailing: const Icon(Icons.add), onTap: () => Get.to(() => const BreakingInfoEntryPage(seriesTitle: 'سری ۲۸ روزه'))),
            ListTile(title: const Text('سری ۹۰ روزه'), trailing: const Icon(Icons.add), onTap: () => Get.to(() => const BreakingInfoEntryPage(seriesTitle: 'سری ۹۰ روزه'))),
            ListTile(title: const Text('سایر'), trailing: const Icon(Icons.add), onTap: () => Get.to(() => const BreakingInfoEntryPage(seriesTitle: 'سایر'))),
          ],
        ),
      ),
    );
  }

  // ویجت نمایش اطلاعات نمونه‌برداری به صورت فقط-خواندنی
  Widget _buildDisplaySamplingInfo() {
    return const Column(
      children: [
        InfoDisplayField(label: 'تاریخ نمونه‌گیری', value: '۱۴۰۴/۰۴/۰۱', icon: Icons.calendar_today),
        InfoDisplayField(label: 'رده بتن', value: 'C25', icon: Icons.grade),
        InfoDisplayField(label: 'نام کارخانه', value: 'بتن آماده تهران', icon: Icons.factory),
        // ... سایر فیلدهای نمایشی
      ],
    );
  }

  // ویجت فرم برای ویرایش اطلاعات نمونه‌برداری
  Widget _buildEditSamplingForm() {
    return Column(
      children: [
        TextFormField(initialValue: '۱۴۰۴/۰۴/۰۱', decoration: const InputDecoration(labelText: 'تاریخ نمونه‌گیری')),
        const SizedBox(height: 16),
        TextFormField(initialValue: 'C25', decoration: const InputDecoration(labelText: 'رده بتن')),
        const SizedBox(height: 16),
        TextFormField(initialValue: 'بتن آماده تهران', decoration: const InputDecoration(labelText: 'نام کارخانه')),
        // ... سایر فیلدهای قابل ویرایش
      ],
    );
  }
}
