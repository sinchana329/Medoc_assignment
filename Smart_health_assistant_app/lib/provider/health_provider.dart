import 'package:flutter/material.dart';
import '../models/health_record.dart';

class HealthProvider extends ChangeNotifier {
  final List<HealthRecord> _records = [];

  List<HealthRecord> get records => _records;

  void addRecord(String title) {
    _records.add(HealthRecord(title: title));
    notifyListeners();
  }
}