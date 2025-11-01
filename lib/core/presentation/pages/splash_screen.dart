import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../features/auth/presentation/provider/auth_provider.dart';

/// SplashScreen: Shows logo and checks authentication on startup.
/// Navigates to dashboard if user is logged in, otherwise to sign-in.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After first frame, run init logic asynchronously.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initApp();
    });
  }

  /// Checks authentication and handles navigation.
  Future<void> _initApp() async {
    // Get a reference to AuthProvider (manages auth state).
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if user is currently logged in.
    final isLoggedIn = authProvider.isLoggedIn;

    if (isLoggedIn) {
      // If logged in, load user profile data.
      await authProvider.loadUserProfile();
      // After loading, double-check widget is still in tree.
      if (!mounted) return;
      // Navigate to dashboard using GoRouter.
      context.go('/dashboard');
    } else {
      // Not logged in - go to sign-in screen.
      if (!mounted) return;
      context.go('/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Shows animated opacity splash with logo and spinner.
    return Scaffold(
      body: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(seconds: 2),
        child: Container(
          decoration: BoxDecoration(
            // Nice gradient background.
            gradient: LinearGradient(
              colors: [Colors.blue.shade500, Colors.blue.shade900],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Wallet",
                  // Beautiful logo font.
                  style: GoogleFonts.lobster(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // Shows loading indicator until navigation.
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}