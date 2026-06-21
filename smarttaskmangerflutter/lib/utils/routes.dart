// ============================================================
// FILE: lib/utils/routes.dart
// PURPOSE: Defines named routes for the app.
//
// NAVIGATION FLOW EXPLANATION:
//   Splash → Home → TaskDetail → AddTask → EditTask → Profile → Settings
//
//   Navigator.push() = Go forward (keeps previous screen in stack)
//   Navigator.pop() = Go back to previous screen
//   Navigator.pushReplacement() = Go forward but remove current screen
//   Navigator.pushAndRemoveUntil() = Go to screen and clear all history
//
//   We use named routes like '/home' instead of hardcoding widget names
//   This makes navigation cleaner and easier to manage
// ============================================================

class AppRoutes {
  // Route name constants - use these instead of typing '/home' everywhere
  static const String splash = '/';          // First screen
  static const String home = '/home';        // Main task list
  static const String taskDetail = '/task-detail';  // Task details
  static const String addTask = '/add-task'; // Add new task
  static const String editTask = '/edit-task'; // Edit existing task
  static const String profile = '/profile';  // User profile
  static const String settings = '/settings'; // App settings
}
