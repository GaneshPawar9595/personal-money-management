import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management/core/presentation/pages/splash_screen.dart';
import 'package:money_management/features/transaction/presentation/pages/transaction_page.dart';
import 'package:provider/provider.dart';

// Import the pages/screens of your app
import 'features/auth/presentation/pages/signup/signup_page.dart';
import 'features/auth/presentation/pages/signin/signin_page.dart';
import 'features/auth/presentation/provider/auth_provider.dart';
import 'features/category/presentation/pages/category_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/profile/presentation/pages/profile_page.dart'; // Dashboard/Home page

final GoRouter router = GoRouter(
  initialLocation: '/splashScreen', // Always start here
  routes: [
    // SplashScreen - always the app's entry gate!
    GoRoute(
      path: '/splashScreen',
      builder: (context, state) => const SplashScreen(),
    ),
    // Sign In
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInPage(),
    ),
    // Sign Up
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
    // Dashboard - requires authentication
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
      redirect: requireAuthGuard,
    ),
    // Category - requires authentication
    GoRoute(
      path: '/category',
      builder: (context, state) {
        final userId = context.read<AuthProvider>().user?.id ?? '';
        return CategoryPage(userId: userId);
      },
      redirect: requireAuthGuard,
    ),
    // Transaction - requires authentication
    GoRoute(
      path: '/transaction',
      builder: (context, state) {
        final userId = context.read<AuthProvider>().user?.id ?? '';
        return TransactionPage(userId: userId);
      },
      redirect: requireAuthGuard,
    ),
    // Profile - requires authentication
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return const ProfilePage(); // Pass userId if needed in your ProfilePage
      },
      redirect: requireAuthGuard,
    ),
  ],
  errorBuilder: (context, state) => const SplashScreen(), // Fallback on route errors
);


/// Redirects to splash screen if user is not authenticated.
String? requireAuthGuard(BuildContext context, GoRouterState state) {
  final auth = context.read<AuthProvider>();
  return auth.user == null ? '/splashScreen' : null;
}