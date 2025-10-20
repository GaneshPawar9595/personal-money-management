import 'package:flutter/material.dart';
import '../../../../../config/localization/app_localizations.dart';
import '../../../../../core/utils/validation.dart';
import '../../../../../shared/widgets/custom_input_field.dart';
import '../../../../../shared/widgets/custom_elevated_button.dart';

/// 📱 **SignUpMobile**
///
/// This widget builds the **mobile layout** for the Sign Up screen.
///
/// It includes:
/// - Title: “Create Account”
/// - Input fields for **Name**, **Phone**, **Email**, and **Password**
/// - A **Sign Up** button
/// - A link to navigate to the **Sign In** page
///
/// Everything is scrollable to ensure it fits on small screens.
class SignUpMobile extends StatelessWidget {
  /// Controller to get/set the **username** text value.
  final TextEditingController usernameController;

  /// Controller for the **email** input field.
  final TextEditingController emailController;

  /// Controller for the **phone number** input field.
  final TextEditingController phoneController;

  /// Controller for the **password** input field.
  final TextEditingController passwordController;

  /// Callback when the user presses the **Sign Up** button.
  final VoidCallback onSignUp;

  /// Callback when the user presses the **Sign In** text button.
  final VoidCallback onNavigateToSignIn;

  /// Whether the page is in **loading** state (e.g. waiting for server response).
  final bool loading;

  /// Whether the password field is currently hidden (●●●●).
  final bool obscurePassword;

  /// Toggles password visibility when the 👁️ icon is tapped.
  final VoidCallback togglePasswordVisibility;

  const SignUpMobile({
    required this.usernameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.onSignUp,
    required this.onNavigateToSignIn,
    required this.loading,
    required this.obscurePassword,
    required this.togglePasswordVisibility,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    /// `loc` gives us access to localized (translated) text for labels and errors.
    final loc = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16), // Space around the form
        child: SingleChildScrollView(
          // Makes the content scrollable for smaller screens
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 🟦 Title
              Text(
                loc!.translate('create_account'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),

              const SizedBox(height: 30),

              /// 🧍 Name Input
              CustomInputField(
                controller: usernameController,
                hintText: loc.translate('name_hint'),
                label: loc.translate('name_label'),
                icon: Icons.person,
                validator: (value) => Validators.validateName(
                  value,
                  loc.translate("ERR_nameRequired"),
                  loc.translate("ERR_nameInvalid"),
                ),
              ),

              const SizedBox(height: 15),

              /// 📞 Phone Input
              CustomInputField(
                controller: phoneController,
                hintText: loc.translate('phone_hint'),
                label: loc.translate('phone_label'),
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => Validators.validatePhone(
                  value,
                  loc.translate("ERR_phoneRequired"),
                  loc.translate("ERR_phoneInvalid"),
                ),
              ),

              const SizedBox(height: 15),

              /// 📧 Email Input
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

              const SizedBox(height: 15),

              /// 🔑 Password Input (with visibility toggle 👁️)
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

              const SizedBox(height: 10),

              /// 🚀 Sign Up Button
              CustomElevatedButton(
                text: loading ? 'Creating Account...' : 'Sign Up',
                onPressed: loading ? null : onSignUp, // Disabled while loading
              ),

              const SizedBox(height: 16),

              /// 🔁 Link to Sign In Page
              TextButton(
                onPressed: loading ? null : onNavigateToSignIn,
                child: const Text(
                  'Already have an account? Sign In',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
