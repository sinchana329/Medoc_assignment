// ============================================================
// FILE: lib/screens/edit_task_screen.dart
// PURPOSE: Edit an existing task. Pre-fills form with current data.
// Uses PUT API via Provider to update.
//
// KEY DIFFERENCE from AddTask:
//   - Receives a TaskModel via arguments
//   - Pre-fills fields in initState()
//   - Calls updateTask() instead of addTask()
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isLoading = false;
  bool _isCompleted = false;   // Track completed toggle
  TaskModel? _task;            // The task being edited

  // -------------------------------------------------------
  // initState(): Pre-fill form fields with existing task data.
  // Called ONCE when screen opens.
  // -------------------------------------------------------
  @override
  void initState() {
    super.initState();

    // Use addPostFrameCallback to safely access route arguments
    // (Arguments are only available after first build completes)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the task passed from TaskDetailScreen
      final task =
      ModalRoute.of(context)!.settings.arguments as TaskModel?;

      if (task != null) {
        setState(() {
          _task = task;
          // PRE-FILL: Set controller text to existing values
          _titleController.text = task.title;
          _descController.text = task.description;
          _isCompleted = task.completed;
        });
      }
    });
  }

  // -------------------------------------------------------
  // dispose(): Free controllers when screen closes
  // -------------------------------------------------------
  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------
  // UPDATE TASK: Validates form, calls PUT API via Provider
  // -------------------------------------------------------
  Future<void> _updateTask() async {
    if (_task == null) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Create updated task using copyWith (keeps unchanged fields)
    final updatedTask = _task!.copyWith(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      completed: _isCompleted,
    );

    // Call Provider → calls PUT API
    final success = await context.read<TaskProvider>().updateTask(updatedTask);

    if (mounted) {
      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.taskUpdated,
                style: GoogleFonts.poppins()),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Pop TWICE: EditTask → TaskDetail → Home
        // Or just pop once to go back to TaskDetail
        Navigator.pop(context); // Back to Task Detail
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update task',
                style: GoogleFonts.poppins()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppStrings.editTaskTitle,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: _task == null
      // Show loading while task loads from arguments
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Header
              Text(
                'Update Task',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'Task #${_task!.id}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 24),

              // ---- TITLE FIELD (pre-filled) ----
              CustomTextField(
                controller: _titleController,
                label: 'Task Title *',
                hint: 'Enter task title',
                prefixIcon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.titleRequired;
                  }
                  if (value.length < 3) {
                    return AppStrings.titleTooShort;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---- DESCRIPTION FIELD (pre-filled) ----
              CustomTextField(
                controller: _descController,
                label: 'Description',
                hint: 'Describe the task...',
                prefixIcon: Icons.description,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.descRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---- COMPLETED TOGGLE ----
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                  BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Mark as Completed',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Switch widget for toggle
                    Switch(
                      value: _isCompleted,
                      onChanged: (val) {
                        setState(() => _isCompleted = val);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ---- UPDATE BUTTON ----
              CustomButton(
                label: AppStrings.update,
                icon: Icons.update,
                isLoading: _isLoading,
                onPressed: _updateTask,
              ),
              const SizedBox(height: 12),

              // ---- CANCEL BUTTON ----
              CustomButton(
                label: AppStrings.cancel,
                color: Colors.grey.shade400,
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
