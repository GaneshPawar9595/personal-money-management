import 'package:flutter/material.dart';
import 'package:money_management/features/auth/presentation/pages/signin/signin_mobile.dart';

/// Tablet layout - shows form in center but slightly wider spacing.
class SignInTablet extends StatelessWidget {
  /// This is the reusable sign-in form section (same one used for mobile).
  final SignInMobile formSection;

  const SignInTablet({required this.formSection, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center the content on the screen
      child: ConstrainedBox(
        // This makes sure the form doesn't grow too wide on tablets.
        // Even if the tablet screen is big, the form's max width will be 500px.
        constraints: const BoxConstraints(maxWidth: 500),

        // The actual sign-in form widget is placed inside this box
        child: formSection,
      ),
    );
  }
}
