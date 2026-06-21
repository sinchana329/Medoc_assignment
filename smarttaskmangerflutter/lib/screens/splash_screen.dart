// ============================================================
// FILE: lib/screens/splash_screen.dart
// PURPOSE: First screen shown when app starts.
//
// LIFECYCLE METHODS USED:
//   initState() = Called ONCE when widget is first created
//   build()     = Called every time widget needs to redraw
//   dispose()   = Called when widget is removed from screen
//
// NAVIGATION: Uses Navigator.pushReplacement() so user can't
// press back to return to splash screen.
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';

// StatefulWidget: Has state that can change over time
// We need state because we use initState() for the timer
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for the logo fade-in effect
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  // -------------------------------------------------------
  // initState(): Called ONCE when screen is first created.
  // Perfect place to:
  //   - Start timers
  //   - Initialize animations
  //   - Begin API calls (in HomeScreen)
  // -------------------------------------------------------
  @override
  void initState() {
    super.initState();  // Always call super.initState() first!

    // Setup fade animation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward(); // Start the animation

    // Navigate to Home after 2 seconds
    // Timer runs once, then calls the function
    Future.delayed(const Duration(seconds: 2), () {
      // Check if widget is still mounted before navigating
      // (Widget might have been removed before timer fires)
      if (mounted) {
        // pushReplacement = replace splash with home (can't go back to splash)
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    });
  }

  // -------------------------------------------------------
  // dispose(): Called when widget is removed from screen.
  // Always dispose controllers to prevent memory leaks!
  // -------------------------------------------------------
  @override
  void dispose() {
    _animController.dispose(); // Free animation resources
    super.dispose();           // Always call super.dispose() last!
  }

  // -------------------------------------------------------
  // build(): Called every time the widget needs to draw itself.
  // Returns the widget tree (UI).
  // -------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Purple gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              Color(0xFF8B7FFF),
              AppColors.primaryLight,
            ],
          ),
        ),
        child: Center(
          // FadeTransition: Animates opacity using our animation
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo icon
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.task_alt,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),

                // App Name
                Text(
                  'Smart Task',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Manager',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 12),

                // Tagline
                Text(
                  'Organize. Focus. Achieve.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 60),

                // Loading indicator at bottom
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white.withOpacity(0.7),
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
