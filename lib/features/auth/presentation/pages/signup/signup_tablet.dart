import 'package:flutter/material.dart';
import 'signup_mobile.dart';

/// 📲 **SignUpTablet**
///
/// This widget defines how the Sign Up screen should look on **tablet devices**.
/// Instead of stretching the form to the full screen width (like mobile),
/// it places the form in the **center** and **limits its max width** so it looks neat.
class SignUpTablet extends StatelessWidget {
  /// The form section (reused from mobile) containing all input fields and buttons.
  final SignUpMobile formSection;

  const SignUpTablet({
    required this.formSection,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      /// Centers the form horizontally and vertically in the screen
      child: ConstrainedBox(
        /// Limits the width of the form to avoid it looking too wide on tablet screens
        constraints: const BoxConstraints(maxWidth: 500),
        child: formSection,
      ),
    );
  }
}
