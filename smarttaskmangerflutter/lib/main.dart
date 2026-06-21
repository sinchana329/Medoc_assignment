// ============================================================
// FILE: lib/main.dart
// PURPOSE: Entry point of the Flutter app.
//
// WIRING EVERYTHING TOGETHER:
//   1. ProviderScope (Riverpod) wraps the entire app
//   2. ChangeNotifierProvider (Provider) wraps MaterialApp
//   3. MaterialApp uses theme from Riverpod themeProvider
//   4. Named routes map strings to screen widgets
//
// HOW IT ALL CONNECTS:
//   main() → runApp(ProviderScope → MyApp)
//   MyApp → Consumer (Riverpod) → ChangeNotifierProvider (Provider) → MaterialApp
//   MaterialApp → routes → Screens
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;  // aliased to avoid clash
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod package
import 'package:google_fonts/google_fonts.dart';

// Providers
import 'providers/task_provider.dart';
import 'riverpod/theme_provider.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/task_detail_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/edit_task_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

// Utils
import 'utils/constants.dart';
import 'utils/routes.dart';

// -------------------------------------------------------
// main(): Flutter app entry point.
// runApp() starts the widget tree.
// -------------------------------------------------------
void main() {
  // ProviderScope: REQUIRED wrapper for Riverpod to work.
  // All Riverpod providers are accessible within this scope.
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// -------------------------------------------------------
// MyApp: Root widget. Sets up Provider + theme + routes.
// ConsumerWidget: Can access Riverpod providers via ref
// -------------------------------------------------------
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch Riverpod themeProvider to rebuild when theme changes
    final themeMode = ref.watch(themeProvider);

    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,  // Hide debug banner

        // ---- THEME SETUP (Controlled by Riverpod themeProvider) ----
        themeMode: themeMode,  // Switches between light and dark

        // Light Theme
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: AppColors.background,
          cardColor: AppColors.cardBg,
          // Apply Poppins font globally via Google Fonts
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),

        // Dark Theme
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF121212),
          cardColor: const Color(0xFF1E1E1E),
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData.dark().textTheme,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),

        // ---- ROUTES: Map route names to screen widgets ----
        // Navigator.pushNamed(context, '/home') uses this map
        initialRoute: AppRoutes.splash,  // Start at splash screen
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.taskDetail: (context) => const TaskDetailScreen(),
          AppRoutes.addTask: (context) => const AddTaskScreen(),
          AppRoutes.editTask: (context) => const EditTaskScreen(),
          AppRoutes.profile: (context) => const ProfileScreen(),
          AppRoutes.settings: (context) => const SettingsScreen(),
        },
      ),
    );
  }
}