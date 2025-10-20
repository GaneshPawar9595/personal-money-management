import 'package:go_router/go_router.dart';

// Import the pages/screens of your app
import 'features/auth/presentation/pages/signup/signup_page.dart';
import 'features/auth/presentation/pages/signin/signin_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart'; // Dashboard/Home page

// Create a router object which handles page navigation in the app
final GoRouter router = GoRouter(
  initialLocation: '/signin', // The first page users see when app opens

  // List of pages/routes in the app
  routes: [
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
  ],
);
