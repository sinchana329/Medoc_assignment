import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';
import '../widgets/chart_bar.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Transaction>('transactions');
    final expenses = box.values.where((tx) => !tx.isIncome).toList();
    final income = box.values.where((tx) => tx.isIncome).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Charts")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: IncomeExpenseChart(
          totalIncome: income.fold(0, (sum, tx) => sum + tx.amount),
          totalExpense: expenses.fold(0, (sum, tx) => sum + tx.amount),
        ),
      ),
    );
  }
}
