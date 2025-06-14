import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart';

// توجه: مسیر ایمپورت‌های زیر را مطابق با ساختار پروژه خودتان اصلاح کنید
import 'package:boton/models/project_model.dart';
import 'package:boton/models/transaction_model.dart';
import 'package:boton/controllers/financial_controller.dart';

// ! <<-- تغییر: FinancialTab حالا یک StatelessWidget است و پروژه را به عنوان ورودی می‌گیرد --!
class FinancialTab extends StatelessWidget {
  final Project project;

  const FinancialTab({super.key, required this.project});

  // متد دیالوگ افزودن تراکنش
  void _showAddTransactionDialog(BuildContext context, FinancialController controller) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final type = controller.transactionTypeToAdd.value; // گرفتن نوع تراکنش از کنترلر

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(type == TransactionType.income ? 'افزودن واریزی جدید' : 'افزودن هزینه جدید'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(labelText: 'مبلغ (تومان)', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'لطفاً یک مبلغ معتبر وارد کنید.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'توضیحات', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) { return 'توضیحات نمی‌تواند خالی باشد.'; }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(child: const Text('لغو'), onPressed: () => Navigator.of(ctx).pop()),
          ElevatedButton(
            child: const Text('افزودن'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newTransaction = Transaction(
                  id: 0, // سرور ID را مشخص می‌کند
                  projectId: controller.project.id, // اتصال به پروژه فعلی
                  type: type,
                  description: descriptionController.text,
                  amount: double.parse(amountController.text),
                  date: DateTime.now(),
                );
                // ! <<-- فراخوانی متد کنترلر به جای setState --!
                controller.addTransaction(newTransaction);
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ! <<-- ۱. کنترلر را با پروژه ورودی می‌سازیم و در GetX ثبت می‌کنیم --!
    final FinancialController controller = Get.put(FinancialController(project));
    final numberFormat = intl.NumberFormat("#,###", "fa_IR");
    initializeDateFormatting('fa_IR', null);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        // ! <<-- ۲. کل ویجت را داخل Obx قرار می‌دهیم تا به تغییرات کنترلر واکنش نشان دهد --!
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFinancialSummaryCard(context, controller, numberFormat),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildActionButton(context, controller, TransactionType.income)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildActionButton(context, controller, TransactionType.expense)),
                  ],
                ),
                const SizedBox(height: 24),
                const Text("تاریخچه تراکنش‌ها", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Divider(height: 20),
                
                // ! <<-- ۳. لیست تراکنش‌ها از کنترلر خوانده می‌شود --!
                if (controller.transactions.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Text("هیچ تراکنشی ثبت نشده است.", style: TextStyle(color: Colors.grey)),
                    ),
                  )
                else
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.transactions.length,
                    itemBuilder: (context, index) {
                      return _buildTransactionListItem(controller.transactions[index], numberFormat);
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                  ),
              ],
            )),
      ),
    );
  }

  // --- تمام ویجت‌های کمکی شما بدون تغییر ساختار باقی می‌مانند ---
  // فقط داده‌ها را از کنترلر می‌خوانند

  Widget _buildActionButton(BuildContext context, FinancialController controller, TransactionType type) {
    bool isIncome = type == TransactionType.income;
    return ElevatedButton.icon(
      onPressed: () {
        controller.transactionTypeToAdd.value = type; // نوع تراکنش را در کنترلر ست می‌کنیم
        _showAddTransactionDialog(context, controller);
      },
      icon: Icon(isIncome ? Icons.add_card_outlined : Icons.credit_card_off_outlined),
      label: Text(isIncome ? 'افزودن واریزی' : 'افزودن هزینه'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isIncome ? Colors.green.shade600 : Colors.red.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );
  }

  Widget _buildFinancialSummaryCard(BuildContext context, FinancialController controller, intl.NumberFormat numberFormat) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("خلاصه وضعیت مالی", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            // ! <<-- ۴. تمام مقادیر از کنترلر خوانده می‌شوند --!
            _buildSummaryRow("مبلغ کل قرارداد:", "${numberFormat.format(controller.project.contractPrice)} تومان"),
            const Divider(height: 24),
            Text("میزان پرداخت: (${(controller.paymentProgress * 100).toStringAsFixed(1)}%)", style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: controller.paymentProgress, minHeight: 8, borderRadius: BorderRadius.circular(4)),
            const SizedBox(height: 16),
            _buildSummaryRow("کل واریزی:", "+ ${numberFormat.format(controller.totalIncome)}", color: Colors.green.shade700),
            _buildSummaryRow("کل برداشتی:", "- ${numberFormat.format(controller.totalExpense)}", color: Colors.red.shade700),
            const Divider(height: 24),
            _buildSummaryRow("مانده حساب (نقدینگی):", numberFormat.format(controller.balance), isBold: true),
            _buildSummaryRow("مانده کل پروژه:", numberFormat.format(controller.project.contractPrice - controller.totalIncome), isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color ?? Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildTransactionListItem(Transaction transaction, intl.NumberFormat numberFormat) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green.shade600 : Colors.red.shade600;
    final icon = isIncome ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down;
    final formattedDate = intl.DateFormat('y/MM/dd', 'fa').format(transaction.date);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(right: BorderSide(color: color, width: 5)),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(transaction.description, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(formattedDate, style: TextStyle(color: Colors.grey[600])),
        trailing: Text(
          '${numberFormat.format(transaction.amount)}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
        ),
      ),
    );
  }
}