import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final isLandscape = orientation == Orientation.landscape;
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;
            final isSmallScreen = screenWidth < 600;

            if (isLandscape) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(),
                          _buildBalanceCard(),
                          _buildMonthSelector(),
                          if (!isSmallScreen) _buildSummaryChart(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildRecentTransactions(),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildBalanceCard(),
                        _buildMonthSelector(),
                        if (screenHeight > 600) _buildSummaryChart(),
                        _buildRecentTransactions(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          if (isSmallScreen) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'income',
                  onPressed: () => _showAddTransactionDialog(TransactionType.income),
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'expense',
                  onPressed: () => _showAddTransactionDialog(TransactionType.expense),
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.remove),
                ),
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                heroTag: 'income',
                onPressed: () => _showAddTransactionDialog(TransactionType.income),
                backgroundColor: Colors.green,
                icon: const Icon(Icons.add),
                label: const Text('Income'),
              ),
              const SizedBox(width: 16),
              FloatingActionButton.extended(
                heroTag: 'expense',
                onPressed: () => _showAddTransactionDialog(TransactionType.expense),
                backgroundColor: Colors.red,
                icon: const Icon(Icons.remove),
                label: const Text('Expense'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Income & Expenses',
            style: TextStyle(
              fontSize: isSmallScreen ? 24 : 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            iconSize: isSmallScreen ? 24 : 32,
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Current Balance',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${provider.balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIncomeExpenseItem(
                      'Income',
                      provider.totalIncome,
                      Colors.green,
                    ),
                    _buildIncomeExpenseItem(
                      'Expenses',
                      provider.totalExpense,
                      Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIncomeExpenseItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month - 1,
                );
              });
            },
          ),
          Text(
            '${_selectedDate.year} - ${_selectedDate.month.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month + 1,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChart() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final expenses = provider.getCategoryExpenses(_selectedDate);
        final isSmallScreen = MediaQuery.of(context).size.width < 600;

        return Card(
          margin: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Summary',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: PieChart(
                    PieChartData(
                      sections: expenses.entries.map((entry) {
                        final category = provider.categories
                            .firstWhere((c) => c.name == entry.key);
                        return PieChartSectionData(
                          color: category.color,
                          value: entry.value,
                          title: '${(entry.value / (provider.totalExpense == 0 ? 1 : provider.totalExpense) * 100).toStringAsFixed(1)}%',
                          radius: isSmallScreen ? 80 : 100,
                          titleStyle: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentTransactions() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final transactions = provider.getTransactionsForMonth(_selectedDate);
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        
        return Card(
          margin: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (transactions.isEmpty)
                  const Center(
                    child: Text('No transactions yet'),
                  )
                else
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: transaction.color.withAlpha(51),
                            child: Icon(
                              transaction.icon,
                              color: transaction.color,
                            ),
                          ),
                          title: Text(
                            transaction.title,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                            ),
                          ),
                          subtitle: Text(
                            transaction.category,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                          trailing: Text(
                            '\$${transaction.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: transaction.color,
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 16 : 18,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddTransactionDialog(TransactionType type) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${type == TransactionType.income ? 'Income' : 'Expense'}'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: context.read<TransactionProvider>().categories
                    .map((category) => DropdownMenuItem(
                          value: category.name,
                          child: Text(category.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedCategory = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && selectedCategory != null) {
                try {
                  final amount = double.parse(amountController.text);
                  final transaction = Transaction(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    amount: amount,
                    date: DateTime.now(),
                    type: type,
                    category: selectedCategory!,
                  );
                  context.read<TransactionProvider>().addTransaction(transaction);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid amount format'),
                    ),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
} 