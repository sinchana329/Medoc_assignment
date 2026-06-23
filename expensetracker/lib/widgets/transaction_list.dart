import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Transaction>('transactions').listenable(),
      builder: (context, Box<Transaction> box, _) {
        if (box.values.isEmpty) {
          return const Center(child: Text("No transactions yet"));
        }
        return ListView.builder(
          itemCount: box.values.length,
          itemBuilder: (context, index) {
            final tx = box.getAt(index)!;
            return ListTile(
              title: Text(tx.category),
              subtitle: Text(tx.date.toString()),
              trailing: Text(
                "${tx.isIncome ? '+' : '-'} ${tx.amount}",
                style: TextStyle(
                  color: tx.isIncome ? Colors.green : Colors.red,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
