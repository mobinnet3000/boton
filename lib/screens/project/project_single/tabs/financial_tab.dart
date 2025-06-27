import 'package:boton/controllers/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart';

// توجه: مسیر ایمپورت‌های زیر را مطابق با ساختار پروژه خودتان اصلاح کنید
import 'package:boton/models/project_model.dart';
import 'package:boton/models/transaction_model.dart';
import 'package:boton/screens/loading/loading.dart';

/// ویجت نمایش وضعیت مالی پروژه.
/// این ویجت به صورت مستقیم به ProjectController گوش می‌دهد.
class FinancialTab extends StatefulWidget {
  final int projectId;

  const FinancialTab({super.key, required this.projectId});

  @override
  State<FinancialTab> createState() => _FinancialTabState();
}

class _FinancialTabState extends State<FinancialTab> {
  // پیدا کردن کنترلر اصلی پروژه
  final ProjectController projectController = Get.find<ProjectController>();

  @override
  void initState() {
    super.initState();
    // این کار برای فرمت تاریخ فارسی لازم است
    initializeDateFormatting('fa_IR', null);
  }

  /// متد نمایش دیالوگ برای افزودن تراکنش جدید
  void _showAddTransactionDialog(BuildContext context, bool isIncome) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(isIncome ? 'افزودن واریزی جدید' : 'افزودن هزینه جدید'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      labelText: 'مبلغ (تومان)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.tryParse(value) == null) {
                        return 'لطفاً یک مبلغ معتبر وارد کنید.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'توضیحات',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'توضیحات نمی‌تواند خالی باشد.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('لغو'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              ElevatedButton(
                child: const Text('افزودن'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // ✅ ساختن Map داده‌ها برای ارسال به API، مطابق با ساختار شما
                    final transactionData = {
                      'project': widget.projectId,
                      'type': isIncome ? "income" : "expense",
                      'description': descriptionController.text,
                      'amount': amountController.text,
                      'date': DateTime.now().toIso8601String(),
                    };

                    // ✅ فراخوانی متد کنترلر اصلی پروژه برای ثبت تراکنش
                    await projectController.addtrans(
                      transactionData,
                      widget.projectId,
                    );

                    // بستن دیالوگ پس از اتمام موفقیت‌آمیز عملیات
                    if (ctx.mounted) {
                      Navigator.of(ctx).pop();
                    }
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = intl.NumberFormat("#,###", "fa_IR");

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // ✅ کلید اصلی: Obx کل UI را در بر می‌گیرد تا به تغییرات ProjectController گوش دهد
      body: Obx(() {
        if (projectController.isLoading.value) {
          return const Loadingg();
        }

        // پروژه مورد نظر را هر بار از لیست به‌روز کنترلر پیدا می‌کنیم
        final project = projectController.projects.firstWhere(
          (p) => p.id == widget.projectId,
          orElse:
              () =>
                  projectController
                      .projects[0], // یک پروژه خالی برای جلوگیری از خطا
        );

        if (project.id == 0) {
          // اگر پروژه پیدا نشد (نباید اتفاق بیفتد)
          return const Center(child: Text("پروژه یافت نشد."));
        }

        // --- انجام محاسبات مالی در لحظه ---
        final totalIncome = project.transactions
            .where((t) => t.type == TransactionType.income)
            .fold<double>(0, (sum, item) => sum + item.amount);

        final totalExpense = project.transactions
            .where((t) => t.type == TransactionType.expense)
            .fold<double>(0, (sum, item) => sum + item.amount);

        final balance = totalIncome - totalExpense;

        final paymentProgress =
            (project.contractPrice > 0)
                ? (totalIncome / project.contractPrice).clamp(0.0, 1.0)
                : 0.0;

        // ------------------------------------

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFinancialSummaryCard(
                context,
                project,
                numberFormat,
                totalIncome,
                totalExpense,
                balance,
                paymentProgress,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(context, TransactionType.income),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(context, TransactionType.expense),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "تاریخچه تراکنش‌ها",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Divider(height: 20),

              if (project.transactions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Text(
                      "هیچ تراکنشی ثبت نشده است.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: project.transactions.length,
                  itemBuilder: (context, index) {
                    // لیست تراکنش ها به ترتیب از جدید به قدیم نمایش داده می شود
                    final transaction =
                        project.transactions.reversed.toList()[index];
                    return _buildTransactionListItem(transaction, numberFormat);
                  },
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 8),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActionButton(BuildContext context, TransactionType type) {
    bool isIncome = type == TransactionType.income;
    return ElevatedButton.icon(
      onPressed: () {
        _showAddTransactionDialog(context, isIncome);
      },
      icon: Icon(
        isIncome ? Icons.add_card_outlined : Icons.credit_card_off_outlined,
      ),
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

  Widget _buildFinancialSummaryCard(
    BuildContext context,
    Project project,
    intl.NumberFormat numberFormat,
    double totalIncome,
    double totalExpense,
    double balance,
    double paymentProgress,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "خلاصه وضعیت مالی",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              "مبلغ کل قرارداد:",
              "${numberFormat.format(project.contractPrice)} تومان",
            ),
            const Divider(height: 24),
            Text(
              "میزان پرداخت: (${(paymentProgress * 100).toStringAsFixed(1)}%)",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: paymentProgress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              "کل واریزی:",
              "+ ${numberFormat.format(totalIncome)}",
              color: Colors.green.shade700,
            ),
            _buildSummaryRow(
              "کل برداشتی:",
              "- ${numberFormat.format(totalExpense)}",
              color: Colors.red.shade700,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              "مانده حساب (نقدینگی):",
              numberFormat.format(balance),
              isBold: true,
            ),
            _buildSummaryRow(
              "مانده کل پروژه:",
              numberFormat.format(project.contractPrice - totalIncome),
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    String value, {
    Color? color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionListItem(
    Transaction transaction,
    intl.NumberFormat numberFormat,
  ) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green.shade600 : Colors.red.shade600;
    final icon = isIncome ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down;
    final formattedDate = intl.DateFormat(
      'y/MM/dd',
      'fa',
    ).format(transaction.date);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(right: BorderSide(color: color, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          formattedDate,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          '${numberFormat.format(transaction.amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ),
    );
  }
}
