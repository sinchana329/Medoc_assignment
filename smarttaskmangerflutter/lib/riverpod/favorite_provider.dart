// ============================================================
// FILE: lib/riverpod/favorite_provider.dart
// PURPOSE: Manages favorite task IDs using Riverpod StateNotifier.
//
// RIVERPOD FLOW:
//   StateNotifier = A class that manages complex state (like a Set)
//   StateNotifierProvider = Exposes a StateNotifier to widgets
//   Widgets use ref.watch(favoriteProvider) to get the Set<int>
//   Widgets use ref.read(favoriteProvider.notifier).toggleFavorite(id) to update
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

// FavoriteNotifier manages the Set of favorite task IDs
class FavoriteNotifier extends StateNotifier<Set<int>> {
  // Initial state: empty set (no favorites)
  FavoriteNotifier() : super({});

  // Toggle: if already favorite, remove it; otherwise add it
  void toggleFavorite(int taskId) {
    if (state.contains(taskId)) {
      // Remove from favorites (create new set without this ID)
      state = {...state}..remove(taskId);
    } else {
      // Add to favorites (create new set with this ID)
      state = {...state, taskId};
    }
    // Riverpod auto-notifies all widgets watching this provider
  }

  // Check if a task is favorite
  bool isFavorite(int taskId) => state.contains(taskId);

  // Clear all favorites
  void clearAll() => state = {};
}

// The provider that widgets will use
// StateNotifierProvider<NotifierClass, StateType>
final favoriteProvider = StateNotifierProvider<FavoriteNotifier, Set<int>>(
      (ref) => FavoriteNotifier(),
);
