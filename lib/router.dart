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

// Create a router object which handles page navigation in the app
final GoRouter router = GoRouter(
  initialLocation: '/splashScreen', // The first page users see when app opens
  // List of pages/routes in the app
  routes: [

    // Sign In Page
    GoRoute(
      path: '/splashScreen', // URL/path for this page
      builder: (context, state) => SplashScreen(), // Widget to display
    ),

    // Sign In Page
    GoRoute(
      path: '/signin', // URL/path for this page
      builder: (context, state) => SignInPage(), // Widget to display
    ),

    // Sign Up Page
    GoRoute(
      path: '/signup', // URL/path for this page
      builder: (context, state) => SignUpPage(), // Widget to display
    ),

    // Dashboard Page (after login)
    GoRoute(
      path: '/dashboard', // URL/path for this page
      builder: (context, state) => DashboardPage(), // Widget to display
    ),

    // Dashboard Page (after login)
    GoRoute(
      path: '/category', // URL/path for this page
      builder: (context, state) {
        final userId = context.read<AuthProvider>().user?.id;
        return CategoryPage(userId: userId!);
      }, // Widget to display
    ),

    GoRoute(
      path: '/transaction', // URL/path for this page
      builder: (context, state) {
        final userId = context.read<AuthProvider>().user?.id;
        return TransactionPage(userId: userId!);
      }, // Widget to display
    ),

    GoRoute(
      path: '/profile', // URL/path for this page
      builder: (context, state) {
        return ProfilePage();
      }, // Widget to display
    ),
  ],
);
