import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Transaction>('transactions');
    final income = box.values.where((tx) => tx.isIncome).fold(0.0, (sum, tx) => sum + tx.amount);
    final expense = box.values.where((tx) => !tx.isIncome).fold(0.0, (sum, tx) => sum + tx.amount);
    final balance = income - expense;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Balance: $balance", style: const TextStyle(fontSize: 22)),
            Text("Income: $income", style: const TextStyle(color: Colors.green)),
            Text("Expense: $expense", style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
