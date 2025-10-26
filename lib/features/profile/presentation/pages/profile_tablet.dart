import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../shared/provider/locale_provider.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_field_tile.dart';
import '../../../../shared/provider/theme_provider.dart';

class ProfileTabletPage extends StatefulWidget {
  const ProfileTabletPage({super.key});

  @override
  State<ProfileTabletPage> createState() => _ProfileTabletPageState();
}

class _ProfileTabletPageState extends State<ProfileTabletPage> {
  bool _editing = false;
  final _picker = ImagePicker();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        _nameCtrl.text = user.name;
        _emailCtrl.text = user.email;
        _phoneCtrl.text = user.phone ?? '';
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final auth = context.read<AuthProvider>();
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    try {
      await auth.updateProfile(name, phone);
      if (!mounted) return;
      setState(() => _editing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  Future<void> _onUploadAvatar() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        final base64Image = base64Encode(bytes);
        if (!mounted) return;
        await context.read<AuthProvider>().updateAvatarBase64(base64Image);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar updated')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload avatar')),
      );
    }
  }

  Future<void> _onRemoveAvatar() async {
    try {
      await context.read<AuthProvider>().updateAvatarBase64('');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar removed')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove avatar')),
      );
    }
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Profile',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      final user = auth.user;

      if (auth.loading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (user == null) {
        return const Scaffold(
          body: Center(child: Text('Redirecting to sign in...')),
        );
      }

      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: _buildTopBar(), // now pinned at the top, outside scroll
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTwoCol = constraints.maxWidth >= 700;
              final hpad = isTwoCol ? 24.0 : 16.0;

              final left = ProfileSectionCard(
                title: 'Personal information',
                trailing: TextButton.icon(
                  onPressed:
                  _editing
                      ? _saveProfile
                      : () => setState(() => _editing = true),
                  icon: Icon(_editing ? Icons.save : Icons.edit, size: 18),
                  label: Text(_editing ? 'Save' : 'Edit'),
                ),
                child: Column(
                  children: [
                    ProfileFieldTile(
                      label: 'Full name',
                      controller: _nameCtrl,
                      enabled: _editing,
                      hintText: 'Enter your name',
                    ),
                    const Divider(height: 1),
                    ProfileFieldTile(
                      label: 'Email',
                      controller: _emailCtrl,
                      enabled: false,
                      hintText: 'Enter your email',
                    ),
                    const Divider(height: 1),
                    ProfileFieldTile(
                      label: 'Phone',
                      controller: _phoneCtrl,
                      enabled: _editing,
                      keyboardType: TextInputType.phone,
                      hintText: 'Enter your phone',
                    ),
                  ],
                ),
              );

              final right = Column(
                children: [
                  ProfileSectionCard(
                    title: 'Preferences',
                    child: Column(
                      children: [
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Dark Mode'),
                          subtitle: const Text('Switch between light and dark themes'),
                          value: Theme.of(context).brightness == Brightness.dark,
                          onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Language'),
                          subtitle: Text(
                            localeProvider.locale.languageCode == 'en'
                                ? 'English (US)'
                                : 'हिन्दी (HI)',
                          ),
                          trailing: OutlinedButton.icon(
                            onPressed: () {
                              final newLocale =
                              localeProvider.locale.languageCode == 'en'
                                  ? const Locale('hi')
                                  : const Locale('en');
                              localeProvider.setLocale(newLocale);
                            },
                            icon: const Icon(Icons.language, size: 18),
                            label: const Text('Change'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProfileSectionCard(
                    title: 'Security',
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.lock),
                          title: const Text('Change password'),
                          subtitle: const Text('Update your account password'),
                          trailing: OutlinedButton(onPressed: () {}, child: const Text('Update')),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Sign out'),
                          subtitle: const Text('You will be asked to sign in again'),
                          trailing: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            onPressed: () async {
                              await context.read<AuthProvider>().signout();
                              if (!mounted) return;
                              context.go('/signin');
                            },
                            child: const Text('Sign out'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: hpad, vertical: 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileHeaderCard(
                          email: _emailCtrl.text.isEmpty ? (user.email) : _emailCtrl.text,
                          name: _nameCtrl.text.isEmpty ? (user.name) : _nameCtrl.text,
                          photoUrl: user.profileImageBytes,
                          onUploadAvatar: _onUploadAvatar,
                          onRemoveAvatar: _onRemoveAvatar,
                        ),
                        const SizedBox(height: 16),
                        if (!isTwoCol) ...[
                          left,
                          const SizedBox(height: 16),
                          right,
                        ] else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: left),
                              const SizedBox(width: 24),
                              Expanded(child: right),
                            ],
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
