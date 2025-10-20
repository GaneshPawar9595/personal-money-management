// Flutter's built-in Material Design library for UI elements
import 'package:flutter/material.dart';

// Provider helps our app manage and share data, like login status
import 'package:provider/provider.dart';

// GoRouter is used here to navigate between app pages
import 'package:go_router/go_router.dart';

// Import the file that handles login (sign-in) logic
import '../../provider/auth_provider.dart';

// A custom widget that adjusts layouts for mobile, tablet, or desktop screens
import '../../../../../shared/widgets/responsive_layout.dart';

// These are the different sign-in screen layouts for various device sizes
import 'signin_mobile.dart';
import 'signin_tablet.dart';
import '../signin/signin_desktop.dart';

// This screen is where users enter their email and password to log in
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

// This stores and manages all the changing information on the screen
class _SignInPageState extends State<SignInPage> {
  // Used to identify and manage the login form's state
  final _formKey = GlobalKey<FormState>();

  // These hold the text entered by the user
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // This controls whether the password is visible or hidden
  bool _obscurePassword = true;

  // This function hides or shows the password when you tap the "eye" icon
  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  /// 🧠 Handles the sign-in process:
  /// - Validates the form
  /// - Calls AuthProvider to log in
  /// - Navigates to the dashboard if successful
  /// - Shows an error message if something goes wrong
  Future<void> _handleSignIn() async {
    // Validate all form fields (returns false if any are invalid)
    if (_formKey.currentState!.validate() == false) {
      return;
    }

    // Get the authentication provider (without rebuilding the UI)
    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      // Try to sign in with email and password
      await auth.signIn(_emailController.text, _passwordController.text);

      // Check if this widget is still in the widget tree before using context
      if (!mounted) return;

      // If sign-in is successful (user is not null), navigate to the dashboard
      if (auth.user != null) {
        context.go('/dashboard');
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
    // Get the authentication state to show loading or error messages if needed
    final auth = Provider.of<AuthProvider>(context);

    // Create the main login form for mobile view with all required actions and states
    final form = SignInMobile(
      emailController: _emailController,
      passwordController: _passwordController,
      onSignIn: () => _handleSignIn(),
      onNavigateToSignUp: () => context.go('/signup'),
      loading: auth.loading, // Shows loading spinner during sign-in
      obscurePassword: _obscurePassword,
      togglePasswordVisibility: _togglePasswordVisibility,
    );

    // This builds the full page; it detects screen size and chooses the correct layout
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ResponsiveLayout(
          mobileLayout: form, // For phone screens
          tabletLayout: SignInTablet(formSection: form), // For tablet screens
          desktopLayout: SignInDesktop(formSection: form), // For desktop view
        ),
      ),
    );
  }
}
