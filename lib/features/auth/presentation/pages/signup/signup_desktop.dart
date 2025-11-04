import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'signup_mobile.dart';

/// 🖥️ **SignUpDesktop**
///
/// This widget builds the **desktop layout** for the Sign Up page.
///
/// It uses a `Row` to place:
/// - The **sign-up form on the left side** 📝
/// - A **Lottie animation on the right side** 🎬
///
/// This layout looks great on large screens (laptops, desktops), giving the form more breathing room.
class SignUpDesktop extends StatelessWidget {
  /// Reusable **sign-up form** section (same one used in mobile layout)
  final SignUpMobile formSection;

  const SignUpDesktop({required this.formSection, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// 🧍 Left margin spacing to keep the form away from the screen edge
        const SizedBox(width: 50),

        /// 📝 Left Side — Sign Up Form
        Expanded(
          flex: 2, // Takes less space than the animation section
          child: formSection,
        ),

        /// Space between form and animation
        const SizedBox(width: 50),

        /// 🎬 Right Side — Lottie Animation / Illustration
        Expanded(
          flex: 3, // Takes more space to give a nice visual balance
          child: Container(
            color: Colors.blueAccent.withValues(alpha: 0.05), // Light background tint
            child: Center(
              child: Lottie.asset(
                'assets/lottie/login_animation.json',
                height: 800,   // Fixed height for consistent look
                repeat: true,  // Loops forever
                animate: true, // Auto-play animation
              ),
            ),
          ),
        ),
      ],
    );
  }
}
