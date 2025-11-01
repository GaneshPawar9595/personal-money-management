import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../category/presentation/pages/category_desktop_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../transaction/presentation/pages/transaction_page.dart';
import '../widgets/desktop/desktop_home_screen.dart';

class DashboardDesktop extends StatefulWidget {
  const DashboardDesktop({super.key});

  @override
  State<DashboardDesktop> createState() => _DashboardDesktopState();
}

class _DashboardDesktopState extends State<DashboardDesktop> {
  int _selectedIndex = 0; // Track selected menu item

  @override
  Widget build(BuildContext context) {
    // Watch for loading/auth state so UI updates on sign-in/out
    final authProvider = context.watch<AuthProvider>();
    final isLoggedIn = authProvider.isLoggedIn;

    // Show spinner while loading profile data.
    if (authProvider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Redirect to sign-in if no user is logged in.
    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;// Make sure this screen is still visible before navigating. [web:101][web:104]
        // Only navigate if not already on /signin to avoid duplicate moves. [web:101][web:104]
        final currentLoc = GoRouterState.of(context).uri.toString();
        if (currentLoc != '/signin') context.go('/signin');
      });
      return const Scaffold(
        body: Center(child: Text('Redirecting to sign in...')),
      );
    }

    // At this point: logged in and not loading—get user info.
    final user = authProvider.user;
    final userId = user?.id ?? '';

    // The right‑side content for each menu option; only the selected one is shown.
    final List<Widget> pages = [
      const DesktopHomeScreen(), // Dashboard overview.
      TransactionPage(userId: userId), // Your transactions list for this user.
      CategoryDesktopPage(userId: userId), // Manage categories for this user.
      const ProfilePage(), // View and edit profile details.
    ];

    // The main layout: left side menu + a thin divider + the main content. [web:101][web:104]
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: false, // Keep the rail compact; just icons and labels. [web:101][web:104]
            selectedIndex: _selectedIndex, // Which item is active. [web:101][web:104]
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index; // Change the main view when a new menu item is picked. [web:101][web:104]
              });
            },
            destinations: const [
              NavigationRailDestination(
                icon: Tooltip(
                  message: 'Dashboard Overview',
                  child: Icon(Icons.dashboard),
                ),
                label: Text('Dashboard Overview'),
              ),
              NavigationRailDestination(
                icon: Tooltip(
                  message: 'Transactions history',
                  child: Icon(Icons.history),
                ),
                label: Text('Transactions history'),
              ),
              NavigationRailDestination(
                icon: Tooltip(
                  message: 'Manage categories',
                  child: Icon(Icons.category),
                ),
                label: Text('Manage categories'),
              ),
              NavigationRailDestination(
                icon: Tooltip(message: 'Profile', child: Icon(Icons.person)),
                label: Text('Profile'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1), // A clean line between menu and content. [web:101][web:104]
          // Keeps all pages alive but shows only the selected one; switching is instant. [web:101][web:104]
          Expanded(child: IndexedStack(index: _selectedIndex, children: pages)), // [web:101][web:104]
        ],
      ),
    );
  }
}
