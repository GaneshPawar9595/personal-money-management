import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:money_management/features/auth/presentation/pages/signin/signin_mobile.dart';

/// 🖥️ **SignInDesktop**
///
/// This widget builds the **desktop version** of the Sign In page.
///
/// It places two sections **side by side** using a Row:
/// 1. **Left side** → A background illustration (Lottie animation)
/// 2. **Right side** → The actual sign-in form (reusing the mobile form)
///
/// This layout is displayed on larger screens (like laptops or desktops).
class SignInDesktop extends StatelessWidget {
  /// This is the login form section, passed from the mobile layout to reuse the same UI.
  final SignInMobile formSection;

  const SignInDesktop({required this.formSection, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// 🟦 LEFT SIDE — Illustration / Animation Section
        Expanded(
          flex: 3, // Takes up more space than the form section
          child: Container(
            color: Colors.blueAccent.withOpacity(0.1), // Light blue background
            child: Center(
              // Center the Lottie animation in the available space
              child: Lottie.asset(
                'assets/lottie/login_animation.json', // Animation file location
                height: 800,   // Set height for a consistent look
                repeat: true,  // Keep looping the animation
                reverse: false,// Play forward only
                animate: true, // Start animation automatically
              ),
            ),
          ),
        ),

        /// Add spacing between the illustration and the form
        const SizedBox(width: 50),

        /// 📝 RIGHT SIDE — Sign In Form Section
        Expanded(
          flex: 2, // Takes slightly less space than the illustration
          child: formSection,
        ),

        /// Add spacing on the far right for a balanced layout
        const SizedBox(width: 50),
      ],
    );
  }
}
