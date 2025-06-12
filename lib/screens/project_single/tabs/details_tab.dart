import 'package:flutter/material.dart';
import 'package:boton/models/project_model.dart';
import '../widgets/info_display_field.dart';

class DetailsTab extends StatefulWidget {
  final Project project;
  const DetailsTab({super.key, required this.project});

  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> {
  bool _isEditing = false;
  late String _selectedTestType;

  @override
  void initState() {
    super.initState();
    _selectedTestType = widget.project.projectid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _isEditing = !_isEditing),
        label: Text(_isEditing ? 'ذخیره تغییرات' : 'ویرایش جزئیات'),
        icon: Icon(_isEditing ? Icons.save_alt_outlined : Icons.edit_outlined),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: _isEditing ? _buildEditForm() : _buildDisplayInfo(),
      ),
    );
  }

  Widget _buildDisplayInfo() {
    final project = widget.project;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('مشخصات کارفرما'),
        InfoDisplayField(
          label: 'نام',
          value: project.clientName,
          icon: Icons.person_outline,
        ),
        InfoDisplayField(
          label: 'شماره تماس',
          value: project.clientPhone,
          icon: Icons.phone_outlined,
        ),
        const Divider(height: 30),
        _buildSectionTitle('مشخصات مهندس ناظر'),
        InfoDisplayField(
          label: 'نام',
          value: project.supervisorName,
          icon: Icons.engineering_outlined,
        ),
        InfoDisplayField(
          label: 'شماره تماس',
          value: project.supervisorPhone,
          icon: Icons.phone_outlined,
        ),
        const Divider(height: 30),
        _buildSectionTitle('مشخصات پروژه'),
        InfoDisplayField(
          label: 'نوع آزمون اصلی',
          value: project.projectid,
          icon: Icons.science_outlined,
        ),
        InfoDisplayField(
          label: 'نوع پروژه',
          value: project.projectType,
          icon: Icons.business_outlined,
        ),
        InfoDisplayField(
          label: 'آدرس',
          value: project.address,
          icon: Icons.location_on_outlined,
        ),
        InfoDisplayField(
          label: 'تعداد طبقه',
          value: '${project.floorCount} طبقه',
          icon: Icons.layers_outlined,
        ),
        InfoDisplayField(
          label: 'تاریخ عقد قرارداد',
          value: project.contractDate,
          icon: Icons.calendar_today_outlined,
        ),
        InfoDisplayField(
          label: 'توضیحات',
          value: project.description,
          icon: Icons.description_outlined,
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    final project = widget.project;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('مشخصات پروژه'),
        const Text(
          'نوع آزمون اصلی پروژه:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        RadioListTile<String>(
          title: const Text('مقاومت فشاری'),
          value: 'مقاومت فشاری',
          groupValue: _selectedTestType,
          onChanged: (v) => setState(() => _selectedTestType = v!),
        ),
        RadioListTile<String>(
          title: const Text('چکش اشمیت'),
          value: 'چکش اشمیت',
          groupValue: _selectedTestType,
          onChanged: (v) => setState(() => _selectedTestType = v!),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: project.address,
          decoration: const InputDecoration(labelText: 'آدرس پروژه'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: project.floorCount.toString(),
          decoration: const InputDecoration(labelText: 'تعداد طبقات'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
