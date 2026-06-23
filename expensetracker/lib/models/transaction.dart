import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  bool isIncome;

  Transaction({
    required this.category,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}
