import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl; // For date formatting
import 'package:intl/date_symbol_data_local.dart'; // Import for initialization

// A simple data model for a transaction
enum TransactionType { income, expense }

class Transaction {
  final TransactionType type;
  final String description;
  final double amount;
  final DateTime date;

  Transaction({
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
  });
}

// The main widget for the financial tab
class FinancialTab extends StatefulWidget {
  const FinancialTab({super.key});

  @override
  State<FinancialTab> createState() => _FinancialTabState();
}

class _FinancialTabState extends State<FinancialTab> {
  // --- MOCK DATA ---
  final double _totalProjectPrice = 80000000; // قیمت کل پروژه
  final List<Transaction> _transactions = [
    Transaction(
      type: TransactionType.income,
      description: "واریز اولیه کارفرما",
      amount: 25000000,
      date: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Transaction(
      type: TransactionType.expense,
      description: "خرید مصالح - سیمان",
      amount: 4500000,
      date: DateTime.now().subtract(const Duration(days: 8)),
    ),
    Transaction(
      type: TransactionType.expense,
      description: "دستمزد کارگران",
      amount: 8000000,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Transaction(
      type: TransactionType.income,
      description: "پرداخت فاز دوم",
      amount: 15000000,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      type: TransactionType.expense,
      description: "هزینه حمل و نقل",
      amount: 1200000,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fa', null);
  }

  void _addTransaction(Transaction transaction) {
    setState(() {
      _transactions.insert(0, transaction);
    });
  }

  void _showAddTransactionDialog(TransactionType type) {
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
            title: Text(
              type == TransactionType.income
                  ? 'افزودن واریزی جدید'
                  : 'افزودن برداشتی جدید',
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
                      type: type,
                      description: descriptionController.text,
                      amount: double.parse(amountController.text),
                      date: DateTime.now(),
                    );
                    _addTransaction(newTransaction);
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
    // Calculate financial summary
    final double totalIncome = _transactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0, (sum, item) => sum + item.amount);
    final double totalExpense = _transactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Financial Summary Card
            _buildFinancialSummaryCard(totalIncome, totalExpense),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(child: _buildActionButton(TransactionType.income)),
                const SizedBox(width: 16),
                Expanded(child: _buildActionButton(TransactionType.expense)),
              ],
            ),
            const SizedBox(height: 24),

            // Transaction List Header
            const Text(
              "تاریخچه تراکنش‌ها",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Divider(height: 20),

            // Transaction List
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                return _buildTransactionListItem(_transactions[index]);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for action buttons
  Widget _buildActionButton(TransactionType type) {
    bool isIncome = type == TransactionType.income;
    return ElevatedButton.icon(
      onPressed: () => _showAddTransactionDialog(type),
      icon: Icon(
        isIncome ? Icons.add_card_outlined : Icons.credit_card_off_outlined,
      ),
      label: Text(isIncome ? 'افزودن واریزی' : 'افزودن برداشتی'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isIncome ? Colors.green.shade600 : Colors.red.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );
  }

  // The main financial summary card
  Widget _buildFinancialSummaryCard(double totalIncome, double totalExpense) {
    final balance = totalIncome - totalExpense;
    final remainingAmount = _totalProjectPrice - totalIncome;
    final paymentProgress =
        (_totalProjectPrice > 0) ? totalIncome / _totalProjectPrice : 0.0;
    final numberFormat = intl.NumberFormat("#,###", "fa");

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
              "${numberFormat.format(_totalProjectPrice)} تومان",
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
              backgroundColor: Colors.grey[200],
              color: Colors.green,
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
              numberFormat.format(remainingAmount),
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

  // A cleaner, more modern transaction list item
  Widget _buildTransactionListItem(Transaction transaction) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green.shade600 : Colors.red.shade600;
    final icon = isIncome ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down;
    final formattedDate = intl.DateFormat(
      'y/MM/dd',
      'fa',
    ).format(transaction.date);
    final numberFormat = intl.NumberFormat("#,###", "fa");

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
