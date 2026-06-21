// ============================================================
// FILE: lib/riverpod/theme_provider.dart
// PURPOSE: Manages dark/light theme using Riverpod StateProvider.
//
// RIVERPOD FLOW EXPLANATION:
//   1. We define a StateProvider (holds a single value with state)
//   2. Widgets use ref.watch(themeProvider) to read the value
//   3. Widgets use ref.read(themeProvider.notifier).state = ... to change it
//   4. All widgets watching this provider auto-rebuild when value changes
//   5. In main.dart, wrap app with ProviderScope (required for Riverpod)
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// StateProvider<ThemeMode>: Holds the current theme (light/dark/system)
// Initial value: ThemeMode.light (app starts in light mode)
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// Helper extension to toggle theme easily
// Usage: ref.read(themeProvider.notifier).state = ThemeMode.dark
