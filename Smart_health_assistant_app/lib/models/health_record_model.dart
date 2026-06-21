class HealthRecordModel {
  final String id;
  final String userId;
  final DateTime date;
  final int? systolic;
  final int? diastolic;
  final int? sugarLevel;
  final int? heartRate;
  final double? weight;
  final String? notes;

  HealthRecordModel({
    required this.id,
    required this.userId,
    required this.date,
    this.systolic,
    this.diastolic,
    this.sugarLevel,
    this.heartRate,
    this.weight,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date.toIso8601String(),
      'systolic': systolic,
      'diastolic': diastolic,
      'sugarLevel': sugarLevel,
      'heartRate': heartRate,
      'weight': weight,
      'notes': notes,
    };
  }

  factory HealthRecordModel.fromMap(Map<String, dynamic> map, String documentId) {
    return HealthRecordModel(
      id: documentId,
      userId: map['userId'] ?? '',
      date: DateTime.parse(map['date']),
      systolic: map['systolic'],
      diastolic: map['diastolic'],
      sugarLevel: map['sugarLevel'],
      heartRate: map['heartRate'],
      weight: map['weight']?.toDouble(),
      notes: map['notes'],
    );
  }
}
