// ============================================================
// FILE: lib/widgets/task_card.dart
// PURPOSE: Card widget for each task shown in the list.
// Uses both Provider (task data) and Riverpod (favorite state).
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../riverpod/favorite_provider.dart';
import '../utils/constants.dart';

// ConsumerWidget: A Riverpod widget that can use ref to access providers
// Use this instead of StatelessWidget when you need Riverpod
class TaskCard extends ConsumerWidget {
  final TaskModel task;
  final VoidCallback onTap;        // When card is tapped → go to detail
  final VoidCallback? onDelete;    // Optional delete callback

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onDelete,
  });

  @override
  // ref is Riverpod's way to access providers
  Widget build(BuildContext context, WidgetRef ref) {
    // Read favorite state from Riverpod
    // ref.watch() = listen for changes, rebuild when favorites change
    final favorites = ref.watch(favoriteProvider);
    final isFavorite = favorites.contains(task.id);

    return GestureDetector(
      onTap: onTap,  // Navigate to task detail on tap
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Left: Completion status circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.completed
                      ? AppColors.success.withOpacity(0.15)
                      : AppColors.warning.withOpacity(0.15),
                ),
                child: Icon(
                  task.completed
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task.completed ? AppColors.success : AppColors.warning,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),

              // Middle: Task title and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        // Strike through if completed
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: task.completed
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        task.completed ? '✓ Completed' : '⏳ Pending',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: task.completed
                              ? AppColors.success
                              : AppColors.warning,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Favorite button
              IconButton(
                onPressed: () {
                  // Toggle favorite using Riverpod
                  // ref.read() = access provider without rebuilding
                  ref.read(favoriteProvider.notifier).toggleFavorite(task.id);
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.accent : Colors.grey,
                  size: 22,
                ),
              ),

              // Arrow icon
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
