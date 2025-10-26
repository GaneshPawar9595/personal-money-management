import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management/features/profile/presentation/pages/profile_page.dart';
import 'package:money_management/features/transaction/presentation/pages/transaction_page.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../category/presentation/pages/category_desktop_page.dart';
import '../widgets/desktop/desktop_home_screen.dart';

/// This screen is the desktop dashboard:
/// it shows a left menu, and the main area on the right changes when you pick a section
/// (Dashboard, Transactions, Categories, Profile).
class DashboardDesktop extends StatefulWidget {
  const DashboardDesktop({super.key}); // Keep it simple: no settings needed to load this page.

  @override
  State<DashboardDesktop> createState() => _DashboardDesktopState(); // Creates the part that handles updates.
}

class _DashboardDesktopState extends State<DashboardDesktop> {
  int _selectedIndex = 0; // Which menu item is chosen right now.

  @override
  Widget build(BuildContext context) {
    // Watch the login state; this will refresh the screen when login changes. [web:101][web:104]
    final auth = context.watch<AuthProvider>(); // [web:101][web:104]
    final user = auth.user; // The person who’s logged in (or nothing if no one). [web:101][web:104]

    // If the app is busy (like logging in or loading profile), show a spinner. [web:101][web:104]
    if (auth.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator())); // [web:101][web:104]
    }

    // If no one is logged in, send the person to the sign‑in screen and show a friendly message. [web:101][web:104]
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return; // Make sure this screen is still visible before navigating. [web:101][web:104]
        // Only navigate if not already on /signin to avoid duplicate moves. [web:101][web:104]
        final currentLoc = GoRouterState.of(context).uri.toString(); // Where we are now. [web:101][web:104]
        if (currentLoc != '/signin')
          context.go('/signin'); // Go to sign‑in if needed.
      });
      return const Scaffold(
        body: Center(child: Text('Redirecting to sign in...')), // Friendly note while moving.
      );
    }

    final userId = user.id; // Handy shortcut for passing into pages that need it.

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
