import 'package:flutter/material.dart';
import 'package:money_management/features/profile/presentation/pages/profile_desktop.dart';
import 'package:money_management/features/profile/presentation/pages/profile_mobile.dart';
import 'package:money_management/features/profile/presentation/pages/profile_tablet.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../../shared/widgets/responsive_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.user;

      if (user == null) return; // user not ready yet
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: ProfileMobilePage(),
      tabletLayout: ProfileTabletPage(),
      desktopLayout: ProfileDesktopPage(),
    );
  }
}
