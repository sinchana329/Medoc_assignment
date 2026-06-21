// ============================================================
// FILE: lib/services/api_service.dart
// PURPOSE: Handles all HTTP API calls to JSONPlaceholder.
// API FLOW EXPLANATION:
//   1. We call a method like getTasks()
//   2. http.get() sends a GET request to the URL
//   3. Response comes back with statusCode and body (JSON string)
//   4. jsonDecode() converts the JSON string to a Dart List/Map
//   5. We map each item to a TaskModel using fromJson()
//   6. Return the list to whoever called this method
// ============================================================

import 'dart:convert';          // For jsonDecode() and jsonEncode()
import 'package:http/http.dart' as http;  // HTTP package
import '../models/task_model.dart';

class ApiService {
  // Base URL for all API calls
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // -------------------------------------------------------
  // GET: Fetch list of tasks from API
  // URL: https://jsonplaceholder.typicode.com/todos
  // Returns a List of TaskModel objects
  // -------------------------------------------------------
  Future<List<TaskModel>> getTasks() async {
    try {
      // Send GET request
      final response = await http.get(Uri.parse('$baseUrl/todos'));

      // Check if request was successful (status 200 = OK)
      if (response.statusCode == 200) {
        // jsonDecode converts JSON string to List<dynamic>
        final List<dynamic> jsonList = jsonDecode(response.body);

        // Take only first 20 tasks (API returns 200, too many for demo)
        return jsonList
            .take(20)
            .map((json) => TaskModel.fromJson(json))  // Convert each Map to TaskModel
            .toList();
      } else {
        throw Exception('Failed to load tasks. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // -------------------------------------------------------
  // POST: Create a new task
  // URL: https://jsonplaceholder.typicode.com/posts
  // Sends task data as JSON, gets back the created task
  // -------------------------------------------------------
  Future<TaskModel> createTask(String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8', // Tell API we're sending JSON
        },
        body: jsonEncode({         // Convert Dart Map to JSON string
          'title': title,
          'body': description,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) { // 201 = Created
        final json = jsonDecode(response.body);
        // JSONPlaceholder returns id:101 for new posts (fake server)
        return TaskModel(
          id: json['id'] ?? 101,
          userId: json['userId'] ?? 1,
          title: title,
          description: description,
          completed: false,
        );
      } else {
        throw Exception('Failed to create task. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // -------------------------------------------------------
  // PUT: Update an existing task
  // URL: https://jsonplaceholder.typicode.com/posts/1
  // Sends updated data and gets back the updated task
  // -------------------------------------------------------
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/posts/${task.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(task.toJson()), // Convert task to JSON
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // Return updated task (keep local fields like isFavorite)
        return task.copyWith(
          title: json['title'] ?? task.title,
          description: json['body'] ?? task.description,
        );
      } else {
        throw Exception('Failed to update task. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // -------------------------------------------------------
  // DELETE: Delete a task by ID
  // URL: https://jsonplaceholder.typicode.com/posts/1
  // Returns true if deleted successfully
  // -------------------------------------------------------
  Future<bool> deleteTask(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$id'),
      );

      // 200 = OK, JSONPlaceholder returns empty body on delete
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
