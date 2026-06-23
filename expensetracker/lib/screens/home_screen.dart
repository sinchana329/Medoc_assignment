import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';
import 'add_transaction_screen.dart';
import '../widgets/transaction_list.dart';
import 'chart_screen.dart';
import 'dashboard_screen.dart';
import 'categories_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Transaction>('transactions');
    final income = box.values.where((tx) => tx.isIncome).fold(0.0, (sum, tx) => sum + tx.amount);
    final expense = box.values.where((tx) => !tx.isIncome).fold(0.0, (sum, tx) => sum + tx.amount);
    final balance = income - expense;

    return Scaffold(
      appBar: AppBar(title: const Text("Expense Tracker")),
      body: Column(
        children: [
          // Balance Summary Card
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Balance: ₹$balance", style: const TextStyle(fontSize: 22)),
                  Text("Income: ₹$income", style: const TextStyle(color: Colors.green)),
                  Text("Expense: ₹$expense", style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),

          // Quick Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add_circle, color: Colors.green),
                label: const Text("Add Income"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTransactionScreen()));
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                label: const Text("Add Expense"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTransactionScreen()));
                },
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Recent Transactions List
          const Expanded(child: TransactionList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
              },
            ),
            ListTile(
              title: const Text("Categories"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesScreen()));
              },
            ),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
            ListTile(
              title: const Text("About"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
              },
            ),
            ListTile(
              title: const Text("Charts"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ChartScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
