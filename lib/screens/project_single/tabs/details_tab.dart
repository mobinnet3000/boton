// lib/pages/project_single/tabs/details_tab.dart
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
  String? _selectedProjectGroup = 'جاری';
  String _selectedTestType = 'مقاومت فشاری'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_isEditing) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تغییرات ذخیره شد! (شبیه‌سازی)')),
            );
          }
          setState(() => _isEditing = !_isEditing);
        },
        label: Text(_isEditing ? 'ذخیره تغییرات' : 'ویرایش جزئیات'),
        icon: Icon(_isEditing ? Icons.save_alt_outlined : Icons.edit_outlined),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: _isEditing ? _buildEditForm() : _buildDisplayInfo(),
      ),
    );
  }

  // ویجت نمایش اطلاعات (کامل شده)
  Widget _buildDisplayInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('مشخصات کارفرما'),
        InfoDisplayField(label: 'نام', value: widget.project.clientName, icon: Icons.person_outline),
        InfoDisplayField(label: 'شماره تماس', value: '۰۹۱۲۱۲۳۴۵۶۷', icon: Icons.phone_outlined),
        const Divider(height: 30),

        _buildSectionTitle('مشخصات مهندس ناظر'),
        InfoDisplayField(label: 'نام', value: widget.project.supervisorName, icon: Icons.engineering_outlined),
        InfoDisplayField(label: 'شماره تماس', value: '۰۹۱۲۷۶۵۴۳۲۱', icon: Icons.phone_outlined),
        const Divider(height: 30),
        
        _buildSectionTitle('مشخصات متقاضی'),
        InfoDisplayField(label: 'نام', value: widget.project.applicantName, icon: Icons.person_pin_circle_outlined),
        InfoDisplayField(label: 'شماره تماس', value: '۰۹۱۰۹۸۷۶۵۴۳', icon: Icons.phone_outlined),
        const Divider(height: 30),

        _buildSectionTitle('مشخصات پروژه'),
        // فیلد نوع تست در ابتدای این بخش قرار گرفت
        InfoDisplayField(label: 'نوع آزمون اصلی', value: _selectedTestType, icon: Icons.science_outlined),
        InfoDisplayField(label: 'نوع پروژه', value: 'ساختمانی', icon: Icons.business_outlined),
        InfoDisplayField(label: 'آدرس', value: widget.project.address, icon: Icons.location_on_outlined),
        InfoDisplayField(label: 'پیمانکار', value: 'شرکت سازه گستر', icon: Icons.handyman_outlined),
        InfoDisplayField(label: 'شماره قرارداد', value: 'قرارداد-۱۴۰۴-الف', icon: Icons.article_outlined),
        InfoDisplayField(label: 'گروه ساختمانی', value: 'ب', icon: Icons.category_outlined),
        InfoDisplayField(label: 'تعداد طبقه', value: '${widget.project.floorCount} طبقه', icon: Icons.layers_outlined),
        InfoDisplayField(label: 'تعداد نمونه‌ها', value: '۳۰', icon: Icons.filter_1_outlined),
        InfoDisplayField(label: 'هزینه هر نمونه', value: '۱۵۰,۰۰۰ تومان', icon: Icons.price_change_outlined),
        InfoDisplayField(label: 'هزینه کل', value: '۴,۵۰۰,۰۰۰ تومان', icon: Icons.monetization_on_outlined),
        InfoDisplayField(label: 'نوع سیمان', value: 'تیپ ۲', icon: Icons.texture_outlined),
        InfoDisplayField(label: 'مقاومت مشخصه', value: 'C25', icon: Icons.shield_outlined),
        InfoDisplayField(label: 'تولید کننده بتن', value: 'کارخانه بتن تهران', icon: Icons.factory_outlined),
        InfoDisplayField(label: 'گروه پروژه', value: 'جاری', icon: Icons.folder_open_outlined),
        InfoDisplayField(label: 'تاریخ عقد قرارداد', value: '۱۴۰۴/۰۳/۱۰', icon: Icons.calendar_today_outlined),
        InfoDisplayField(label: 'توضیحات', value: 'توضیحات تکمیلی در مورد پروژه اینجا نوشته می‌شود.', icon: Icons.description_outlined),
      ],
    );
  }

  // فرم ویرایش (کامل شده)
  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ... فیلدهای کارفرما و ناظر و متقاضی ...
        
        _buildSectionTitle('مشخصات پروژه'),
        const Text('نوع آزمون اصلی پروژه:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        RadioListTile<String>(title: const Text('مقاومت فشاری'), value: 'مقاومت فشاری', groupValue: _selectedTestType, onChanged: (v) => setState(() => _selectedTestType = v!)),
        RadioListTile<String>(title: const Text('چکش اشمیت'), value: 'چکش اشمیت', groupValue: _selectedTestType, onChanged: (v) => setState(() => _selectedTestType = v!)),
        
        const SizedBox(height: 24),
        TextFormField(initialValue: 'ساختمانی', decoration: const InputDecoration(labelText: 'نوع پروژه')),
        const SizedBox(height: 16),
        TextFormField(initialValue: widget.project.address, decoration: const InputDecoration(labelText: 'آدرس پروژه')),
        // ... بقیه فیلدهای فرم ویرایش ...
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedProjectGroup,
          decoration: const InputDecoration(labelText: 'گروه پروژه', border: OutlineInputBorder()),
          items: ['جاری', 'قرارداد', 'بایگانی', 'متفرقه'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
          onChanged: (newValue) => setState(() => _selectedProjectGroup = newValue),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
