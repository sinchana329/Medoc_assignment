// ============================================================
// FILE: lib/providers/task_provider.dart
// PURPOSE: Manages the state of tasks using Provider package.
//
// PROVIDER FLOW EXPLANATION:
//   1. TaskProvider extends ChangeNotifier
//   2. It holds the list of tasks and loading/error state
//   3. When data changes, notifyListeners() tells all widgets to rebuild
//   4. Widgets use context.watch<TaskProvider>() to listen for changes
//   5. Widgets use context.read<TaskProvider>() to call methods
//   6. In main.dart, we wrap app with ChangeNotifierProvider
// ============================================================

import 'package:flutter/foundation.dart';  // For ChangeNotifier
import '../models/task_model.dart';
import '../services/api_service.dart';

class TaskProvider extends ChangeNotifier {
  // Private variables (underscore = private in Dart)
  final ApiService _apiService = ApiService();
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Public GETTERS - widgets read these values
  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // -------------------------------------------------------
  // FETCH TASKS: Called in initState() of HomeScreen
  // Gets tasks from API and stores in _tasks list
  // -------------------------------------------------------
  Future<void> fetchTasks() async {
    _isLoading = true;          // Show loading spinner
    _errorMessage = '';
    notifyListeners();           // Tell widgets to rebuild (show spinner)

    try {
      _tasks = await _apiService.getTasks();  // Call API
      _isLoading = false;
      notifyListeners();         // Tell widgets to rebuild (show tasks)
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();         // Tell widgets to rebuild (show error)
    }
  }

  // -------------------------------------------------------
  // ADD TASK: Called from AddTaskScreen
  // Calls POST API and adds new task to local list
  // -------------------------------------------------------
  Future<bool> addTask(String title, String description) async {
    try {
      final newTask = await _apiService.createTask(title, description);

      // Add to beginning of list so user sees it immediately
      _tasks.insert(0, newTask);
      notifyListeners(); // Rebuild all listening widgets
      return true;       // Success
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;      // Failure
    }
  }

  // -------------------------------------------------------
  // UPDATE TASK: Called from EditTaskScreen
  // Calls PUT API and updates task in local list
  // -------------------------------------------------------
  Future<bool> updateTask(TaskModel updatedTask) async {
    try {
      final result = await _apiService.updateTask(updatedTask);

      // Find the task in list and replace it
      final index = _tasks.indexWhere((t) => t.id == result.id);
      if (index != -1) {
        _tasks[index] = result;
        notifyListeners(); // Rebuild widgets with new data
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // -------------------------------------------------------
  // DELETE TASK: Called from TaskDetailScreen
  // Calls DELETE API and removes task from local list
  // UPDATE UI IMMEDIATELY: We remove from list right away
  // -------------------------------------------------------
  Future<bool> deleteTask(int taskId) async {
    try {
      // Remove from local list immediately (optimistic update)
      // This makes UI feel fast even before API responds
      _tasks.removeWhere((t) => t.id == taskId);
      notifyListeners(); // Rebuild UI without the deleted task

      // Then call API in background
      await _apiService.deleteTask(taskId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // -------------------------------------------------------
  // TOGGLE COMPLETED: Mark task as done/undone locally
  // -------------------------------------------------------
  void toggleCompleted(int taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].completed = !_tasks[index].completed;
      notifyListeners();
    }
  }

  // -------------------------------------------------------
  // TOGGLE FAVORITE: Mark/unmark task as favorite
  // Works with Riverpod favorite_provider too
  // -------------------------------------------------------
  void toggleFavorite(int taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].isFavorite = !_tasks[index].isFavorite;
      notifyListeners();
    }
  }

  // -------------------------------------------------------
  // SEARCH TASKS: Filter tasks by search query
  // Returns filtered list (doesn't change _tasks)
  // -------------------------------------------------------
  List<TaskModel> searchTasks(String query) {
    if (query.isEmpty) return _tasks;
    return _tasks
        .where((task) =>
        task.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
