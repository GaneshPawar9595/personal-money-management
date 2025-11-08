import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../config/localization/app_localizations.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../category/presentation/pages/category_desktop_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../transaction/presentation/pages/transaction_page.dart';
import 'desktop_home_screen.dart';

class DashboardDesktop extends StatefulWidget {
  const DashboardDesktop({super.key});

  @override
  State<DashboardDesktop> createState() => _DashboardDesktopState();
}

class _DashboardDesktopState extends State<DashboardDesktop> {
  int _selectedIndex = 0; // Track selected menu item

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
      return Scaffold(
        body: Center(child: Text(loc.translate('redirecting_to_splash_screen'))),
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
            destinations: [
              NavigationRailDestination(
                icon: Tooltip(
                  message: loc.translate('dashboard_overview'),
                  child: Icon(Icons.dashboard),
                ),
                label: Text(loc.translate('dashboard_overview')),
              ),
              NavigationRailDestination(
                icon: Tooltip(
                  message: loc.translate('transactions_history'),
                  child: Icon(Icons.history),
                ),
                label: Text(loc.translate('transactions_history')),
              ),
              NavigationRailDestination(
                icon: Tooltip(
                  message: loc.translate('manage_categories'),
                  child: Icon(Icons.category),
                ),
                label: Text(loc.translate('manage_categories')),
              ),
              NavigationRailDestination(
                icon: Tooltip(message: loc.translate('profile'),
                    child: Icon(Icons.person)),
                label: Text(loc.translate('profile')),
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
