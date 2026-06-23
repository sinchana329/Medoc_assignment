import 'package:hive/hive.dart';
import '../models/transaction.dart';

class HiveService {
  final Box<Transaction> box = Hive.box<Transaction>('transactions');

  void addTransaction(Transaction transaction) {
    box.add(transaction);
  }

  List<Transaction> getTransactions() {
    return box.values.toList();
  }
}
