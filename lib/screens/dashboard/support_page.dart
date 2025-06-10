// lib/pages/dashboard/support_page.dart
import 'dart:io'; // برای کار با فایل (در آینده)
import 'package:flutter/material.dart';
import 'package:boton/utils/snackbar_helper.dart'; // برای نمایش پیام موفقیت

// Enum برای اولویت
enum Priority { normal, important, urgent }

extension PriorityExtension on Priority {
  String get name {
    switch (this) {
      case Priority.normal:
        return 'عادی';
      case Priority.important:
        return 'مهم';
      case Priority.urgent:
        return 'فوری';
    }
  }
}

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // برای گسترش در آینده، از TabController استفاده می‌کنیم
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          title: const TabBar(
            tabs: [
              Tab(text: 'ارسال تیکت جدید'),
              Tab(text: 'لیست تیکت‌های من'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SubmitTicketView(),
            MyTicketsView(), // فعلا یک Placeholder
          ],
        ),
      ),
    );
  }
}

// ویجت اصلی برای فرم ارسال تیکت
class SubmitTicketView extends StatefulWidget {
  const SubmitTicketView({super.key});

  @override
  State<SubmitTicketView> createState() => _SubmitTicketViewState();
}

class _SubmitTicketViewState extends State<SubmitTicketView> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDepartment;
  Priority _selectedPriority = Priority.normal;
  String? _attachedFileName;

  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      // TODO: منطق ارسال تیکت به بک‌اند در اینجا قرار می‌گیرد
      print('عنوان: ${_titleController.text}');
      print('بخش: $_selectedDepartment');
      print('اولویت: $_selectedPriority');
      print('پیام: ${_messageController.text}');
      print('فایل پیوست: $_attachedFileName');

      // نمایش پیام موفقیت
      SnackbarHelper.showSuccess(
        title: 'ارسال موفق',
        message: 'تیکت شما با موفقیت ثبت شد و به زودی بررسی خواهد شد.',
      );

      // پاک کردن فرم بعد از ارسال
      setState(() {
        _formKey.currentState!.reset();
        _titleController.clear();
        _messageController.clear();
        _selectedDepartment = null;
        _selectedPriority = Priority.normal;
        _attachedFileName = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('ارسال تیکت جدید', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('لطفاً مشکل خود را با جزئیات کامل شرح دهید تا سریع‌تر به آن رسیدگی شود.'),
            const SizedBox(height: 32),

            // فیلد عنوان
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'عنوان تیکت'),
              validator: (value) => (value == null || value.isEmpty) ? 'لطفاً عنوان تیکت را وارد کنید' : null,
            ),
            const SizedBox(height: 20),

            // انتخاب بخش
            DropdownButtonFormField<String>(
              value: _selectedDepartment,
              decoration: const InputDecoration(labelText: 'بخش مربوطه'),
              hint: const Text('یک بخش را انتخاب کنید'),
              items: ['پشتیبانی فنی', 'امور مالی', 'پیشنهادات و انتقادات']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedDepartment = value),
              validator: (value) => value == null ? 'لطفاً بخش مربوطه را انتخاب کنید' : null,
            ),
            const SizedBox(height: 24),
            
            // انتخاب اولویت
            const Text('اولویت:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SegmentedButton<Priority>(
              segments: Priority.values.map((priority) {
                return ButtonSegment<Priority>(
                  value: priority,
                  label: Text(priority.name),
                );
              }).toList(),
              selected: {_selectedPriority},
              onSelectionChanged: (newSelection) {
                setState(() => _selectedPriority = newSelection.first);
              },
            ),
            const SizedBox(height: 24),

            // فیلد متن پیام
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'متن پیام',
                alignLabelWithHint: true, // برای هماهنگی لیبل با فیلدهای چند خطی
                hintText: 'مشکل خود را به طور کامل شرح دهید...',
              ),
              maxLines: 5,
              validator: (value) => (value == null || value.isEmpty) ? 'لطفاً متن پیام را وارد کنید' : null,
            ),
            const SizedBox(height: 24),

            // بخش پیوست فایل
            OutlinedButton.icon(
              onPressed: () {
                // TODO: منطق انتخاب فایل با پکیج file_picker
                // فعلا فقط نام فایل را به صورت شبیه‌سازی شده نمایش می‌دهیم
                setState(() {
                  _attachedFileName = 'screenshot-1.png';
                });
              },
              icon: const Icon(Icons.attach_file),
              label: const Text('پیوست کردن فایل'),
            ),
            if (_attachedFileName != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Chip(
                  label: Text(_attachedFileName!),
                  onDeleted: () => setState(() => _attachedFileName = null),
                ),
              ),
            
            const SizedBox(height: 40),

            // دکمه ارسال
            ElevatedButton(
              onPressed: _submitTicket,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white
              ),
              child: const Text('ارسال تیکت'),
            ),
          ],
        ),
      ),
    );
  }
}

// ویجت Placeholder برای تب "لیست تیکت‌ها"
class MyTicketsView extends StatelessWidget {
  const MyTicketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_edu, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text('لیست تیکت‌های قبلی شما در اینجا نمایش داده خواهد شد.', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
