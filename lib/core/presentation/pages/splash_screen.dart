import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/features/transaction/presentation/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

import '../../../features/auth/presentation/provider/auth_provider.dart';
import '../../../features/category/presentation/provider/category_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Schedule an asynchronous task to run just after the build context is ready
    Future.microtask(() async {
      // Obtain providers without subscribing to updates (avoid rebuilds here)
      if (!mounted) return; // Widget disposed, don't proceed
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

      if (auth.user != null) {
        // If user is authenticated, load categories for that user
        await categoryProvider.loadCategories(auth.user!.id);
        await transactionProvider.loadTransactions(auth.user!.id);

        // Once categories are loaded, navigate to dashboard
        if (!mounted) return; // Widget disposed, don't proceed
        context.go('/dashboard');
      } else {
        // No user logged in, navigate to signup/login page
        if (!mounted) return; // Widget disposed, don't proceed
        context.go('/signup');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background to match app branding
        decoration: BoxDecoration(
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
              // Uncomment this line to add your app logo
              // Image.asset('assets/logo.png', height: 120),
              const SizedBox(height: 20),

              // App name styled with Google Fonts Lobster
              Text(
                "Wallet",
                style: GoogleFonts.lobster(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Circular progress spinner indicating loading
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
