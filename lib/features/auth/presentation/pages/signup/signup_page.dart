import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';            // Handles page navigation
import 'package:provider/provider.dart';              // Manages app state (e.g., authentication status)

import '../../../../../shared/widgets/responsive_layout.dart';  // Chooses layout based on screen size
import '../../provider/auth_provider.dart';                      // Provides sign up logic and user state

import 'signup_mobile.dart';
import 'signup_tablet.dart';
import 'signup_desktop.dart';

/// 📝 **SignUpPage**
///
/// This is the main Sign Up screen that appears on mobile, tablet, or desktop.
/// It collects user info (name, email, phone, password) and calls the sign-up logic.
/// Based on screen size, it switches between mobile / tablet / desktop layouts.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  /// Key used to validate the entire sign-up form.
  final _formKey = GlobalKey<FormState>();

  /// Text controllers to read the input from text fields.
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Controls whether the password is hidden (●●●●) or visible.
  bool _obscurePassword = true;

  /// Toggles the password visibility when the 👁️ icon is pressed.
  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  /// 🧠 **Handles the sign-up process** when the user taps the "Sign Up" button.
  ///
  /// Steps:
  /// 1. Validate the form fields (name, email, phone, password)
  /// 2. Call `auth.signUp` from the AuthProvider
  /// 3. If successful, navigate to `/dashboard`
  /// 4. If error occurs, show it as a toast
  Future<void> _handleSignUp() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      // 1️⃣ Validate all fields before calling sign-up
      if (_formKey.currentState!.validate()) {
        // 2️⃣ Call sign-up logic from provider
        await auth.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _usernameController.text.trim(),
          _phoneController.text.trim(),
        );

        // 3️⃣ If user is created successfully → go to Dashboard
        if (auth.user != null) {
          if (!mounted) return; // Ensures widget is still active
          context.go('/dashboard');
        }
      }
    } catch (e) {
      // Check again if mounted before showing UI feedback
      if (!mounted) return;

      // Show error message in a SnackBar (red box at the bottom)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Watches the authentication state (e.g. to show loading indicator during sign up)
    final auth = Provider.of<AuthProvider>(context);

    /// 📱 **Form Section**
    /// Reuses the `SignUpMobile` widget and passes all controllers, state, and callbacks.
    /// The same widget is used inside tablet and desktop layouts.
    final form = SignUpMobile(
      usernameController: _usernameController,
      emailController: _emailController,
      phoneController: _phoneController,
      passwordController: _passwordController,
      onSignUp: _handleSignUp,
      onNavigateToSignIn: () => context.go('/signin'),
      loading: auth.loading,
      obscurePassword: _obscurePassword,
      togglePasswordVisibility: _togglePasswordVisibility,
    );

    /// 🖥️ **Responsive Layout**
    /// Uses the `ResponsiveLayout` widget to switch between mobile, tablet, and desktop.
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ResponsiveLayout(
          mobileLayout: form,                             // Shown on phones
          tabletLayout: SignUpTablet(formSection: form),   // Shown on tablets
          desktopLayout: SignUpDesktop(formSection: form), // Shown on wide screens
        ),
      ),
    );
  }
}
