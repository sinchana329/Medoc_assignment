// FILE: lib/screens/add_task_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isLoading = false;
  String? _attachedFileName;
  String? _attachedFilePath;

  @override
  void initState() {
    super.initState();
    // initState: runs once when screen opens
  }

  @override
  void dispose() {
    // dispose: free controllers to avoid memory leaks
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _attachedFileName = file.name;
          _attachedFilePath = file.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick file: $e', style: GoogleFonts.poppins()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await context.read<TaskProvider>().addTask(
      _titleController.text.trim(),
      _descController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.taskAdded, style: GoogleFonts.poppins()),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add task', style: GoogleFonts.poppins()),
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
        title: Text(AppStrings.addTaskTitle,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Create a New Task',
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
              Text('Fill in the details below',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textGrey)),
              const SizedBox(height: 24),

              // Title field
              CustomTextField(
                controller: _titleController,
                label: 'Task Title *',
                hint: 'e.g. Buy groceries',
                prefixIcon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) return AppStrings.titleRequired;
                  if (value.length < 3) return AppStrings.titleTooShort;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description field
              CustomTextField(
                controller: _descController,
                label: 'Description *',
                hint: 'Describe the task...',
                prefixIcon: Icons.description,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) return AppStrings.descRequired;
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Attachment label
              Text('Attachment (Optional)',
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGrey)),
              const SizedBox(height: 8),

              // File picker button
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _attachedFileName != null
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    color: _attachedFileName != null
                        ? AppColors.primary.withOpacity(0.05)
                        : Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _attachedFileName != null
                            ? Icons.attach_file
                            : Icons.upload_file,
                        color: _attachedFileName != null
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _attachedFileName ?? 'Tap to attach a file',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: _attachedFileName != null
                                ? AppColors.primary
                                : Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_attachedFileName != null)
                        IconButton(
                          icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _attachedFileName = null;
                              _attachedFilePath = null;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save button (POST API)
              CustomButton(
                label: AppStrings.save,
                icon: Icons.save,
                isLoading: _isLoading,
                onPressed: _saveTask,
              ),
              const SizedBox(height: 12),

              // Cancel button
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