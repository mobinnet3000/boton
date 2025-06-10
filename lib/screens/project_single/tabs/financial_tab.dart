// lib/pages/project_single/tabs/financial_tab.dart
import 'package:flutter/material.dart';

class FinancialTab extends StatelessWidget {
  const FinancialTab({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildFinancialCard(
            context: context,
            title: 'گزارش کلی مالی',
            description: 'دریافت گزارش کامل شامل تمام هزینه‌ها، پرداخت‌ها و مانده حساب پروژه.',
          ),
          const SizedBox(height: 20),
          _buildFinancialCard(
            context: context,
            title: 'لیست تراکنش‌ها',
            description: 'مشاهده لیست تمام تراکنش‌های مالی ثبت شده برای این پروژه به تفکیک تاریخ.',
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard({required BuildContext context, required String title, required String description}) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_for_offline_outlined),
              label: Text('دریافت گزارش $title'),
            )
          ],
        ),
      ),
    );
  }
}
