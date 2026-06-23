import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ["Food", "Travel", "Shopping", "Loan", "Others"];
    final box = Hive.box<Transaction>('transactions');

    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          // Filter transactions by category
          final filtered = box.values.where((tx) => tx.category == category).toList();
          final totalIncome = filtered.where((tx) => tx.isIncome).fold(0.0, (sum, tx) => sum + tx.amount);
          final totalExpense = filtered.where((tx) => !tx.isIncome).fold(0.0, (sum, tx) => sum + tx.amount);

          return ListTile(
            title: Text(category),
            subtitle: Text("Income: ₹$totalIncome | Expense: ₹$totalExpense"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryDetailScreen(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final String category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Transaction>('transactions');
    final filtered = box.values.where((tx) => tx.category == category).toList();

    return Scaffold(
      appBar: AppBar(title: Text("$category Transactions")),
      body: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final tx = filtered[index];
          return ListTile(
            title: Text(tx.category),
            subtitle: Text(tx.date.toString()),
            trailing: Text(
              "${tx.isIncome ? '+' : '-'} ${tx.amount}",
              style: TextStyle(color: tx.isIncome ? Colors.green : Colors.red),
            ),
          );
        },
      ),
    );
  }
}
