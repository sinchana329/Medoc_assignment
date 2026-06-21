// ============================================================
// FILE: lib/models/task_model.dart
// PURPOSE: Defines the TaskModel class used throughout the app.
// JSON PARSING EXPLANATION:
//   - fromJson() converts a Map (from API JSON) into a TaskModel object
//   - toJson() converts a TaskModel object back to a Map (to send to API)
// ============================================================

class TaskModel {
  final int id;          // Unique task ID from API
  final int userId;      // Which user this task belongs to
  String title;          // Task title
  String description;    // Task description (we add this locally)
  bool completed;        // Is the task done?
  bool isFavorite;       // Marked as favorite (local only)
  String? attachedFile;  // File path attached to task (local only)

  TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description = '',
    required this.completed,
    this.isFavorite = false,
    this.attachedFile,
  });

  // FACTORY CONSTRUCTOR: Creates a TaskModel from JSON Map
  // Called like: TaskModel.fromJson(jsonData)
  // Example JSON: {"id": 1, "userId": 1, "title": "Buy milk", "completed": false}
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? 'No Title',
      description: json['body'] ?? json['description'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  // METHOD: Converts TaskModel to JSON Map (used when sending to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': description,
      'completed': completed,
    };
  }

  // METHOD: Creates a copy of task with some changed values
  // Used when editing a task - we don't mutate, we copy
  TaskModel copyWith({
    String? title,
    String? description,
    bool? completed,
    bool? isFavorite,
    String? attachedFile,
  }) {
    return TaskModel(
      id: this.id,
      userId: this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      isFavorite: isFavorite ?? this.isFavorite,
      attachedFile: attachedFile ?? this.attachedFile,
    );
  }
}
