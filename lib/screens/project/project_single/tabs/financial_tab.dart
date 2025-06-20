import 'package:boton/controllers/base_controller.dart';
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
  void _showAddTransactionDialog(
    BuildContext context,
    FinancialController controller,
  ) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final type =
        controller.transactionTypeToAdd.value; // گرفتن نوع تراکنش از کنترلر

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          type == TransactionType.income
              ? 'افزودن واریزی جدید'
              : 'افزودن هزینه جدید',
        ),
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
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newTransaction = Transaction(
                  id: DateTime.now().millisecondsSinceEpoch, // سرور ID را مشخص می‌کند
                  projectId: project.id,
                  type: type,
                  description: descriptionController.text,
                  amount: double.parse(amountController.text),
                  date: DateTime.now(),
                );
                
                // ✅✅✅ ۱. کلید حل مشکل: فراخوانی متد کنترلر ✅✅✅
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
    // ✅✅✅ ۲. بهینه‌سازی: استفاده از تگ برای جلوگیری از خطای Get.put مکرر ✅✅✅
    final FinancialController controller = Get.put(
      FinancialController(project),
      tag: 'financial_${project.id}', // یک نام منحصر به فرد برای کنترلر هر پروژه
    );
    final numberFormat = intl.NumberFormat("#,###", "fa_IR");
    initializeDateFormatting('fa_IR', null);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx( // این بخش از کد شما کاملاً درست بود و دست نخورده باقی ماند
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFinancialSummaryCard(context, controller, numberFormat),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      controller,
                      TransactionType.income,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      controller,
                      TransactionType.expense,
                    ),
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

              if (controller.transactions.isEmpty)
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
                  itemCount: controller.transactions.length,
                  itemBuilder: (context, index) {
                    return _buildTransactionListItem(
                      controller.transactions[index],
                      numberFormat,
                    );
                  },
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 8),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ویجت‌های کمکی شما
  Widget _buildActionButton(
    BuildContext context,
    FinancialController controller,
    TransactionType type,
  ) {
    bool isIncome = type == TransactionType.income;
    return ElevatedButton.icon(
      onPressed: () {
        controller.transactionTypeToAdd.value = type;
        
        // ✅✅✅ ۳. اصلاح فراخوانی دیالوگ ✅✅✅
        _showAddTransactionDialog(context, controller);
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
    FinancialController controller,
    intl.NumberFormat numberFormat,
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
            // ! <<-- ۴. تمام مقادیر از کنترلر خوانده می‌شوند --!
            _buildSummaryRow(
              "مبلغ کل قرارداد:",
              "${numberFormat.format(controller.project.contractPrice)} تومان",
            ),
            const Divider(height: 24),
            Text(
              "میزان پرداخت: (${(controller.paymentProgress * 100).toStringAsFixed(1)}%)",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: controller.paymentProgress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              "کل واریزی:",
              "+ ${numberFormat.format(controller.totalIncome)}",
              color: Colors.green.shade700,
            ),
            _buildSummaryRow(
              "کل برداشتی:",
              "- ${numberFormat.format(controller.totalExpense)}",
              color: Colors.red.shade700,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              "مانده حساب (نقدینگی):",
              numberFormat.format(controller.balance),
              isBold: true,
            ),
            _buildSummaryRow(
              "مانده کل پروژه:",
              numberFormat.format(
                controller.project.contractPrice - controller.totalIncome,
              ),
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

Future<void> showAddSampleDialog({
  // ✅ خروجی تابع void است چون دیگر نیازی به بازگرداندن نمونه نداریم
  required BuildContext context,
  required int projectId,
  required bool income,
  String? initialCategory,
}) async {
  final formWidgetKey = GlobalKey<_AddSampleFormContentState>();

  return showDialog<void>(
    // ✅ اینجا هم void است
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('ایجاد ${income ? "واریزی" : "برداشت"} جدید'),
        content: SingleChildScrollView(
          // ============================================
          child: _AddSampleFormContent(
            key: formWidgetKey,
            initialCategory: initialCategory,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () async {
              // ✅ دکمه ثبت باید async باشد
              final formState = formWidgetKey.currentState;
              if (formState != null &&
                  formState.formKey.currentState!.validate()) {
                // ✅ ۱. ساختن Map داده‌ها برای ارسال به API
                final sampleData = {
                  'project': projectId as int,
                  'type': income ? "income" : "expense",
                  //  ارسال تاریخ میلادی استاندارد===========================================
                  'description': formState.disController.text as String,
                  'amount': formState.amontController.text as String,
                  'date': DateTime.now().toIso8601String(),
                };

                // ✅ ۲. فراخوانی متد کنترلر برای ارسال داده و آپدیت state
                await Get.find<ProjectController>().addtrans(
                  sampleData,
                  projectId,
                );

                // ✅ ۳. بستن دیالوگ پس از اتمام کار
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('ثبت'),
          ),
        ],
      );
    },
  );
}

class _AddSampleFormContent extends StatefulWidget {
  // کلید فرم از بیرون به این ویجت داده می‌شود تا به دکمه‌ها دسترسی داشته باشیم
  const _AddSampleFormContent({super.key, this.initialCategory});

  final String? initialCategory;

  @override
  State<_AddSampleFormContent> createState() => _AddSampleFormContentState();
}

class _AddSampleFormContentState extends State<_AddSampleFormContent> {
  final formKey = GlobalKey<FormState>();

  // کنترلرها و متغیرها داخل State تعریف می‌شوند
  final amontController = TextEditingController();
  final disController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // فلاتر به صورت خودکار و در زمان مناسب این متد را فراخوانی می‌کند
    amontController.dispose();
    disController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // این متد فقط UI فرم را می‌سازد
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: amontController,
            decoration: const InputDecoration(
              labelText: 'مبلغ(ریال)',
              prefixIcon: Icon(Icons.monetization_on_outlined),
            ),
            validator: (v) => v!.isEmpty ? 'این فیلد الزامی است' : null,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: disController,
            decoration: const InputDecoration(
              labelText: 'توضیحات',
              prefixIcon: Icon(Icons.description),
            ),
            validator: (v) => v!.isEmpty ? 'تاریخ الزامی است' : null,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
