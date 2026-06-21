import 'package:flutter/material.dart';
import '../models/health_record_model.dart';
import '../models/medicine_model.dart';

class HealthProvider extends ChangeNotifier {
  List<HealthRecordModel> _records = [];
  List<MedicineModel> _medicines = [];
  bool _isLoading = false;

  List<HealthRecordModel> get records => _records;
  List<MedicineModel> get medicines => _medicines;
  bool get isLoading => _isLoading;

  HealthProvider() {
    // Adding dummy data for now
    _loadDummyData();
  }

  void _loadDummyData() {
    _records = [
      HealthRecordModel(
        id: '1',
        userId: 'dummy',
        date: DateTime.now().subtract(const Duration(days: 1)),
        systolic: 120,
        diastolic: 80,
        heartRate: 72,
        weight: 70.5,
      ),
      HealthRecordModel(
        id: '2',
        userId: 'dummy',
        date: DateTime.now(),
        systolic: 118,
        diastolic: 78,
        heartRate: 75,
        weight: 70.3,
      ),
    ];

    _medicines = [
      MedicineModel(
        id: '1',
        userId: 'dummy',
        name: 'Vitamin C',
        dosage: '1 Pill',
        time: '08:00',
        isTaken: false,
      ),
      MedicineModel(
        id: '2',
        userId: 'dummy',
        name: 'Paracetamol',
        dosage: '500mg',
        time: '14:00',
        isTaken: true,
      ),
    ];
    notifyListeners();
  }

  Future<void> addHealthRecord(HealthRecordModel record) async {
    _records.add(record);
    notifyListeners();
  }

  Future<void> addMedicine(MedicineModel medicine) async {
    _medicines.add(medicine);
    notifyListeners();
  }

  Future<void> toggleMedicineTaken(String id) async {
    final index = _medicines.indexWhere((m) => m.id == id);
    if (index != -1) {
      final med = _medicines[index];
      _medicines[index] = MedicineModel(
        id: med.id,
        userId: med.userId,
        name: med.name,
        dosage: med.dosage,
        time: med.time,
        isTaken: !med.isTaken,
      );
      notifyListeners();
    }
  }
}
