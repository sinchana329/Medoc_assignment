// ============================================================
// FILE: lib/screens/settings_screen.dart
// PURPOSE: App settings. Controls dark mode and task filter.
//   - Dark Mode toggle → updates Riverpod themeProvider
//   - Filter (All/Completed/Pending) → updates Riverpod filterProvider
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../riverpod/theme_provider.dart';
import '../riverpod/filter_provider.dart';
import '../riverpod/favorite_provider.dart';
import '../utils/constants.dart';

// ConsumerWidget: Riverpod widget (stateless, just reads providers)
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read current theme from Riverpod
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    // Read current filter from Riverpod
    final currentFilter = ref.watch(filterProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppStrings.settingsTitle,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- SECTION: Appearance ----
            _sectionHeader('Appearance'),
            const SizedBox(height: 10),

            // Dark Mode Switch
            _buildSettingCard(
              context,
              icon: isDark ? Icons.dark_mode : Icons.light_mode,
              title: 'Dark Mode',
              subtitle: isDark
                  ? 'Switch to light theme'
                  : 'Switch to dark theme',
              trailing: Switch(
                value: isDark,
                onChanged: (value) {
                  // Riverpod: update themeProvider state
                  ref.read(themeProvider.notifier).state =
                  value ? ThemeMode.dark : ThemeMode.light;
                },
                activeColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),

            // ---- SECTION: Task Filters ----
            _sectionHeader('Task Filters'),
            Text(
              'Choose which tasks to display on the home screen',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 10),

            // Filter options: All, Completed, Pending
            // Loop through all filter values
            ...TaskFilter.values.map((filter) {
              final isSelected = currentFilter == filter;
              return GestureDetector(
                onTap: () {
                  // Riverpod: update filterProvider state
                  ref.read(filterProvider.notifier).state = filter;
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : Theme.of(context).cardColor,
                    borderRadius:
                    BorderRadius.circular(AppSizes.borderRadius),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade200,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Filter icon
                      Icon(
                        _getFilterIcon(filter),
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textGrey,
                        size: 22,
                      ),
                      const SizedBox(width: 14),
                      // Filter label
                      Expanded(
                        child: Text(
                          filterLabels[filter]!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? AppColors.primary
                                : Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color,
                          ),
                        ),
                      ),
                      // Selected checkmark
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // ---- SECTION: Data ----
            _sectionHeader('Data'),
            const SizedBox(height: 10),

            // Clear favorites button
            _buildSettingCard(
              context,
              icon: Icons.favorite_border,
              title: 'Clear All Favorites',
              subtitle: 'Remove all tasks from favorites',
              trailing: TextButton(
                onPressed: () {
                  // Riverpod: call clearAll on FavoriteNotifier
                  ref.read(favoriteProvider.notifier).clearAll();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('All favorites cleared',
                          style: GoogleFonts.poppins()),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Text(
                  'Clear',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // App version
            Center(
              child: Text(
                'Smart Task Manager v1.0.0\nBuilt with Flutter 💙',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Section header text
  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }

  // Helper: Builds a settings row card
  Widget _buildSettingCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Widget trailing,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  // Helper: get icon for each filter
  IconData _getFilterIcon(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return Icons.list_alt;
      case TaskFilter.completed:
        return Icons.check_circle_outline;
      case TaskFilter.pending:
        return Icons.hourglass_empty;
    }
  }
}
