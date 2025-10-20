import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/provider/auth_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: auth.user == null
            ? const CircularProgressIndicator()
            : Text(
          'Welcome, ${auth.user!.name}',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
