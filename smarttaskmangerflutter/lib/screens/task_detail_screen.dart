// ============================================================
// FILE: lib/screens/task_detail_screen.dart
// PURPOSE: Shows full details of a task. Has Edit and Delete buttons.
//
// NAVIGATION:
//   - Receives TaskModel as argument from HomeScreen
//   - Edit button → Navigator.push() to EditTaskScreen
//   - Delete button → calls DELETE API, then Navigator.pop() back
//   - Favorite button → uses Riverpod to toggle
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../riverpod/favorite_provider.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../widgets/custom_button.dart';

// ConsumerStatefulWidget = StatefulWidget with Riverpod access
class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  bool _isDeleting = false;  // Track delete button loading state

  // -------------------------------------------------------
  // DELETE TASK: Calls DELETE API, updates UI, goes back
  // -------------------------------------------------------
  Future<void> _deleteTask(TaskModel task) async {
    // Show confirm dialog before deleting
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Task?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${task.title}"? This cannot be undone.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),  // Cancel
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),   // Confirm
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.cardRadius)),
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isDeleting = true);

      // Call DELETE via Provider
      // context.read() = call method without rebuilding
      final success =
      await context.read<TaskProvider>().deleteTask(task.id);

      if (mounted) {
        setState(() => _isDeleting = false);
        if (success) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.taskDeleted,
                  style: GoogleFonts.poppins()),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Go back to home screen (task is already removed from list)
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete task',
                  style: GoogleFonts.poppins()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the task passed from HomeScreen via Navigator arguments
    final task = ModalRoute.of(context)!.settings.arguments as TaskModel;

    // Watch Riverpod favorite state
    final favorites = ref.watch(favoriteProvider);
    final isFavorite = favorites.contains(task.id);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppStrings.detailTitle,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        // Back button auto-added by Flutter (Navigator.pop)
        actions: [
          // Favorite toggle in AppBar
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.accent : Colors.white,
            ),
            onPressed: () {
              ref.read(favoriteProvider.notifier).toggleFavorite(task.id);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- STATUS CARD ----
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: task.completed
                      ? [AppColors.success, const Color(0xFF81C784)]
                      : [AppColors.warning, const Color(0xFFFFB74D)],
                ),
                borderRadius:
                BorderRadius.circular(AppSizes.cardRadius),
              ),
              child: Row(
                children: [
                  Icon(
                    task.completed ? Icons.check_circle : Icons.pending,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.completed ? 'Completed' : 'Pending',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Task #${task.id}',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (isFavorite)
                    const Icon(Icons.favorite,
                        color: Colors.white, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---- TASK TITLE ----
            _buildInfoCard(
              context,
              icon: Icons.title,
              label: 'Task Title',
              content: task.title,
            ),
            const SizedBox(height: 12),

            // ---- DESCRIPTION ----
            _buildInfoCard(
              context,
              icon: Icons.description,
              label: 'Description',
              content: task.description.isEmpty
                  ? 'No description provided'
                  : task.description,
            ),
            const SizedBox(height: 12),

            // ---- TASK ID ----
            _buildInfoCard(
              context,
              icon: Icons.tag,
              label: 'Task ID',
              content: '#${task.id}',
            ),
            const SizedBox(height: 32),

            // ---- EDIT BUTTON ----
            CustomButton(
              label: 'Edit Task',
              icon: Icons.edit,
              onPressed: () {
                // Push EditTask screen, pass task as argument
                Navigator.pushNamed(
                  context,
                  AppRoutes.editTask,
                  arguments: task,
                );
              },
            ),
            const SizedBox(height: 12),

            // ---- DELETE BUTTON ----
            CustomButton(
              label: 'Delete Task',
              icon: Icons.delete_outline,
              color: Colors.red.shade400,
              isLoading: _isDeleting,
              onPressed: () => _deleteTask(task),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper: builds a styled info card
  Widget _buildInfoCard(BuildContext context,
      {required IconData icon,
        required String label,
        required String content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
