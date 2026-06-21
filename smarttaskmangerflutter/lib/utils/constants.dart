// ============================================================
// FILE: lib/utils/constants.dart
// PURPOSE: App-wide constants like colors, strings, sizes.
// Keeps magic values in one place for easy changes.
// ============================================================

import 'package:flutter/material.dart';

class AppColors {
  // Primary color used for AppBar, buttons, accents
  static const Color primary = Color(0xFF6C63FF);      // Purple
  static const Color primaryLight = Color(0xFF9C94FF);
  static const Color accent = Color(0xFFFF6584);       // Pink/Red accent
  static const Color success = Color(0xFF4CAF50);      // Green (completed)
  static const Color warning = Color(0xFFFF9800);      // Orange (pending)
  static const Color background = Color(0xFFF5F5F5);   // Light grey bg
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF333333);
  static const Color textGrey = Color(0xFF888888);
}

class AppStrings {
  // App name
  static const String appName = 'Smart Task Manager';

  // Screen titles
  static const String homeTitle = 'My Tasks';
  static const String addTaskTitle = 'Add New Task';
  static const String editTaskTitle = 'Edit Task';
  static const String profileTitle = 'Profile';
  static const String settingsTitle = 'Settings';
  static const String detailTitle = 'Task Detail';

  // Button labels
  static const String save = 'Save Task';
  static const String update = 'Update Task';
  static const String delete = 'Delete Task';
  static const String cancel = 'Cancel';

  // Validation messages
  static const String titleRequired = 'Please enter a title';
  static const String descRequired = 'Please enter a description';
  static const String titleTooShort = 'Title must be at least 3 characters';

  // Success messages
  static const String taskAdded = 'Task added successfully!';
  static const String taskUpdated = 'Task updated successfully!';
  static const String taskDeleted = 'Task deleted successfully!';
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 12.0;
  static const double cardRadius = 16.0;
  static const double buttonHeight = 52.0;
  static const double iconSize = 24.0;
}
