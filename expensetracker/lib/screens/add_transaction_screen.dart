import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/hive_service.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isIncome = false;

  final HiveService _hiveService = HiveService();

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        category: _categoryController.text,
        amount: double.parse(_amountController.text),
        date: DateTime.now(),
        isIncome: _isIncome,
      );
      _hiveService.addTransaction(transaction);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Category"),
                validator: (value) =>
                value!.isEmpty ? "Enter category" : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? "Enter amount" : null,
              ),
              SwitchListTile(
                title: const Text("Income?"),
                value: _isIncome,
                onChanged: (val) => setState(() => _isIncome = val),
              ),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
