import 'package:flutter/material.dart';
import '../../../../../config/localization/app_localizations.dart';
import '../../../../../core/utils/validation.dart';
import '../../../../../shared/widgets/custom_input_field.dart';
import '../../../../../shared/widgets/custom_elevated_button.dart';

/// Mobile layout for the Sign In screen
class SignInMobile extends StatelessWidget {
  /// Controller to get or modify the text typed in the **email** field.
  final TextEditingController emailController;

  /// Controller to get or modify the text typed in the **password** field.
  final TextEditingController passwordController;

  /// What should happen when the user taps the **Login** button.
  final VoidCallback onSignIn;

  /// What should happen when the user taps **"Sign Up"**.
  final VoidCallback onNavigateToSignUp;

  /// Whether the screen should show a loading state (e.g., when logging in).
  final bool loading;

  /// Whether the password is currently hidden (true = password dots).
  final bool obscurePassword;

  /// Function to **toggle** the password visibility (👁️ show/hide).
  final VoidCallback togglePasswordVisibility;

  const SignInMobile({
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
    required this.onNavigateToSignUp,
    required this.loading,
    required this.obscurePassword,
    required this.togglePasswordVisibility,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    /// `loc` gives us access to translated text based on the user's language.
    /// Example: loc.translate('welcome_label') → "Welcome" (or another language)
    final loc = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16), // Adds space around the form
        child: SingleChildScrollView(
          // Makes content scrollable if the screen is too small
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🟦 Welcome Title
              Text(
                loc!.translate('welcome_label'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),

              const SizedBox(height: 40), // Space below the title

              /// 📧 Email Input Field
              CustomInputField(
                controller: emailController,
                hintText: loc.translate('email_hint'),
                label: loc.translate('email_label'),
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.validateEmail(
                  value,
                  loc.translate("ERR_emailRequired"),
                  loc.translate("ERR_invalidEmail"),
                ),
              ),

              const SizedBox(height: 15), // Space between fields

              /// 🔑 Password Input Field (with visibility toggle 👁️)
              CustomInputField(
                controller: passwordController,
                hintText: loc.translate('password_hint'),
                label: loc.translate('password_label'),
                icon: Icons.lock,
                isPassword: true,
                obscureText: obscurePassword,
                obscureState: obscurePassword,
                toggleObscure: togglePasswordVisibility,
                validator: (value) => Validators.validatePassword(
                  value,
                  loc.translate("ERR_passwordTooShort"),
                ),
              ),

              const SizedBox(height: 25), // Space before login button

              /// 🚪 Login Button
              CustomElevatedButton(
                text: loc.translate('login_button'),
                onPressed: loading ? null : onSignIn,
                // Disabled when `loading` is true
              ),

              /// 📝 "Don't have an account? Sign up"
              TextButton(
                onPressed: onNavigateToSignUp,
                child: Text(loc.translate('signup_prompt')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
