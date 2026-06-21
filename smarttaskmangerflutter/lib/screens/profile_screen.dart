// ============================================================
// FILE: lib/screens/profile_screen.dart
// PURPOSE: User profile screen.
//   - Pick profile image from gallery using image_picker
//   - Show selected image
//   - Toggle dark/light theme using Riverpod
// ============================================================

import 'dart:io';                              // For File class
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // Image picker package
import '../riverpod/theme_provider.dart';
import '../utils/constants.dart';

// ConsumerStatefulWidget = StatefulWidget + Riverpod access
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _profileImage;   // Holds the selected image file
  final ImagePicker _picker = ImagePicker();  // Image picker instance

  // -------------------------------------------------------
  // PICK IMAGE: Opens gallery to select profile photo
  // -------------------------------------------------------
  Future<void> _pickImage() async {
    try {
      // Pick image from gallery (not camera)
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,  // From gallery
        imageQuality: 80,             // Compress to 80% quality
        maxWidth: 512,                // Max width 512px
        maxHeight: 512,               // Max height 512px
      );

      if (pickedFile != null) {
        // Update state with new image
        setState(() {
          _profileImage = File(pickedFile.path);  // Create File from path
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick image: $e',
                style: GoogleFonts.poppins()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch theme state from Riverpod
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppStrings.profileTitle,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // ---- PROFILE PICTURE SECTION ----
            Center(
              child: Stack(
                children: [
                  // Profile image or placeholder
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    // If image is selected, show it; else show icon
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)  // Show picked image
                        : null,
                    child: _profileImage == null
                        ? const Icon(
                      Icons.person,
                      size: 65,
                      color: AppColors.primary,
                    )
                        : null,
                  ),

                  // Camera icon to pick new image
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: _pickImage,  // Open gallery when tapped
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tap to change text
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library,
                  color: AppColors.primary, size: 18),
              label: Text(
                'Change Profile Photo',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // User name
            Text(
              'John Doe',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'john.doe@email.com',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 32),

            // ---- PROFILE INFO CARDS ----
            _buildInfoRow(Icons.person_outline, 'Username', 'john_doe'),
            _buildInfoRow(Icons.phone_outlined, 'Phone', '+91 98765 43210'),
            _buildInfoRow(Icons.location_on_outlined, 'Location', 'India'),
            const SizedBox(height: 24),

            // ---- THEME TOGGLE ----
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dark Mode',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          isDark ? 'Currently dark' : 'Currently light',
                          style: GoogleFonts.poppins(
                            color: AppColors.textGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Riverpod theme toggle switch
                  Switch(
                    value: isDark,
                    onChanged: (value) {
                      // Update Riverpod themeProvider state
                      // ref.read() to access notifier and change state
                      ref.read(themeProvider.notifier).state =
                      value ? ThemeMode.dark : ThemeMode.light;
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: builds a profile info row
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textGrey)),
              Text(value,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
