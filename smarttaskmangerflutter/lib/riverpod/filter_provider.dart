// ============================================================
// FILE: lib/riverpod/filter_provider.dart
// PURPOSE: Manages task filter selection using Riverpod StateProvider.
//
// Filter options: all, completed, pending
// Used in Settings screen to filter which tasks appear on Home screen
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Enum to represent filter choices clearly
enum TaskFilter {
  all,        // Show all tasks
  completed,  // Show only completed tasks
  pending,    // Show only pending tasks
}

// StateProvider<TaskFilter>: Holds current filter selection
// Initial value: TaskFilter.all (show all tasks by default)
final filterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);

// Label map for displaying filter names in UI
const Map<TaskFilter, String> filterLabels = {
  TaskFilter.all: 'All Tasks',
  TaskFilter.completed: 'Completed',
  TaskFilter.pending: 'Pending',
};
