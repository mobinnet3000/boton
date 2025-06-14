// lib/controllers/financial_controller.dart (فایل جدید)
import 'package:get/get.dart';
import '../models/project_model.dart';
import '../models/transaction_model.dart';
// import '../services/api_service.dart'; // سرویسی برای ارسال درخواست به API

class FinancialController extends GetxController {
  final Project project;
  
  var transactions = <Transaction>[].obs;
  var transactionTypeToAdd = TransactionType.income.obs;
  
  FinancialController(this.project);

  @override
  void onInit() {
    super.onInit();
    // داده‌های اولیه را از پروژه گرفته شده، بارگذاری می‌کنیم
    transactions.value = project.transactions;
  }
  
  // متدهای محاسباتی
  double get totalIncome => transactions
      .where((tx) => tx.type == TransactionType.income)
      .fold(0, (sum, item) => sum + item.amount);

  double get totalExpense => transactions
      .where((tx) => tx.type == TransactionType.expense)
      .fold(0, (sum, item) => sum + item.amount);
      
  double get balance => totalIncome - totalExpense;
  
  double get paymentProgress => (project.contractPrice > 0) ? totalIncome / project.contractPrice : 0.0;

  Future<void> addTransaction(Transaction newTransaction) async {
    // TODO: اینجا باید درخواست POST به /api/transactions/ ارسال شود
    // await ApiService.createTransaction(newTransaction);
    
    // برای نمایش فوری در UI، به صورت لوکال اضافه می‌کنیم
    // در حالت واقعی، بعد از پاسخ موفق سرور، لیست را دوباره از سرور می‌گیریم
    transactions.insert(0, newTransaction);
    if (newTransaction.type == TransactionType.income) {
      project.totalIncome += newTransaction.amount;
    } else {
      project.totalExpense += newTransaction.amount;
    }
  }
}