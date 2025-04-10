import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../models/budget.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [];
  final List<Budget> _budgets = [];
  final List<Category> _categories = Category.defaultCategories;

  List<Transaction> get transactions => _transactions;
  List<Budget> get budgets => _budgets;
  List<Category> get categories => _categories;

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void addBudget(Budget budget) {
    _budgets.add(budget);
    notifyListeners();
  }

  List<Transaction> getTransactionsForMonth(DateTime date) {
    return _transactions.where((t) =>
        t.date.year == date.year && t.date.month == date.month).toList();
  }

  Map<String, double> getCategoryExpenses(DateTime date) {
    final transactions = getTransactionsForMonth(date)
        .where((t) => t.type == TransactionType.expense);
    
    Map<String, double> categoryExpenses = {};
    for (var transaction in transactions) {
      categoryExpenses[transaction.category] =
          (categoryExpenses[transaction.category] ?? 0) + transaction.amount;
    }
    return categoryExpenses;
  }
} 