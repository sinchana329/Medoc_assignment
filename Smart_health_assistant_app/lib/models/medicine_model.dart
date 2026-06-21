class MedicineModel {
  final String id;
  final String userId;
  final String name;
  final String dosage;
  final String time; // Format: HH:mm
  final bool isTaken;

  MedicineModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.dosage,
    required this.time,
    this.isTaken = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'dosage': dosage,
      'time': time,
      'isTaken': isTaken,
    };
  }

  factory MedicineModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MedicineModel(
      id: documentId,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      time: map['time'] ?? '',
      isTaken: map['isTaken'] ?? false,
    );
  }
}
