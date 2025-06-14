// lib/models/transaction_model.dart (یک فایل جدید بسازید)
enum TransactionType { income, expense }

class Transaction {
  final int id;
  final TransactionType type;
  final String description;
  final double amount;
  final DateTime date;

  Transaction({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: (json['type'] as String) == 'income' 
          ? TransactionType.income 
          : TransactionType.expense,
      description: json['description'],
      amount: double.parse(json['amount'].toString()),
      date: DateTime.parse(json['date']),
    );
  }
}

// --- در مدل پروژه خود این فیلدها را اضافه کنید ---
// lib/models/project_model.dart
class Project {
  // ... فیلدهای قبلی
  
  // ! <<-- فیلدهای مالی جدید --!
  final double contractPrice;
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<Transaction> transactions;

  // ... کانستراکتور را آپدیت کنید
  const Project({
    // ...,
    required this.contractPrice,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.transactions,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      // ...,
      contractPrice: double.parse(json['contract_price'].toString()),
      totalIncome: double.parse(json['total_income'].toString()),
      totalExpense: double.parse(json['total_expense'].toString()),
      balance: double.parse(json['balance'].toString()),
      transactions: (json['transactions'] as List<dynamic>)
          .map((txJson) => Transaction.fromJson(txJson))
          .toList(),
    );
  }
}