import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../config/localization/app_localizations.dart';
import '../../../../shared/provider/locale_provider.dart';
import '../../../../shared/provider/theme_provider.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_field_tile.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDesktopPage extends StatefulWidget {
  const ProfileDesktopPage({super.key});

  @override
  State<ProfileDesktopPage> createState() => _ProfileDesktopPageState();
}

class _ProfileDesktopPageState extends State<ProfileDesktopPage> {
  bool _editing = false;
  final picker = ImagePicker();

  // Editable controllers
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize fields safely after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        _nameCtrl.text = user.name;
        _emailCtrl.text = user.email;
        _phoneCtrl.text = user.phone ?? '';
      }
      setState(() {}); // refresh once
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() => _editing = !_editing);
  }

  Future<void> _saveProfile() async {
    final auth = context.read<AuthProvider>();
    final updatedName = _nameCtrl.text.trim();
    final updatedPhone = _phoneCtrl.text.trim();

    auth.updateProfile(updatedName, updatedPhone);

    setState(() => _editing = false);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Use watch() for rebuilds (reactive)
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.user;

        if (auth.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) context.go('/signin');
          });
          return const Scaffold(
            body: Center(child: Text('Redirecting to sign in...')),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ========== HEADER ==========
                          ProfileHeaderCard(
                            email:
                                _emailCtrl.text.isEmpty
                                    ? (user.email)
                                    : _emailCtrl.text,
                            name:
                                _nameCtrl.text.isEmpty
                                    ? (user.name)
                                    : _nameCtrl.text,
                            photoUrl: user.profileImageBytes,
                            onUploadAvatar: _onUploadAvatar,
                            onRemoveAvatar: _onRemoveAvatar,
                          ),
                          const SizedBox(height: 24),

                          // ========== MAIN GRID ==========
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // -------- LEFT COLUMN --------
                                  Expanded(
                                    child: ProfileSectionCard(
                                      title:
                                          loc?.translate('personal_info') ??
                                          'Personal information',
                                      trailing: TextButton.icon(
                                        onPressed:
                                            _editing
                                                ? _saveProfile
                                                : _toggleEdit,
                                        icon: Icon(
                                          _editing ? Icons.save : Icons.edit,
                                          size: 18,
                                        ),
                                        label: Text(
                                          _editing
                                              ? loc?.translate('save') ?? 'Save'
                                              : loc?.translate('edit') ?? 'Edit',
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          ProfileFieldTile(
                                            label: loc?.translate('name_label') ?? 'Full name',
                                            controller: _nameCtrl,
                                            enabled: _editing,
                                            hintText: loc?.translate('name_hint') ??'Enter your name',
                                          ),
                                          const Divider(height: 1),
                                          ProfileFieldTile(
                                            label: loc?.translate('email_label') ?? 'Email',
                                            controller: _emailCtrl,
                                            enabled: false, // Immutable
                                            hintText: loc?.translate('email_hint') ?? 'Enter your email',
                                          ),
                                          const Divider(height: 1),
                                          ProfileFieldTile(
                                            label: loc?.translate('phone_label') ?? 'Phone',
                                            controller: _phoneCtrl,
                                            enabled: _editing,
                                            keyboardType: TextInputType.phone,
                                            hintText: loc?.translate('password_hint') ?? 'Enter your password',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),

                                  // -------- RIGHT COLUMN --------
                                  Expanded(
                                    child: Column(
                                      children: [
                                        // Preferences Section
                                        ProfileSectionCard(
                                          title:
                                              loc?.translate('preferences') ??
                                              'Preferences',
                                          child: Column(
                                            children: [
                                              SwitchListTile.adaptive(
                                                contentPadding: EdgeInsets.zero,
                                                title: const Text('Dark Mode'),
                                                subtitle: const Text(
                                                  'Switch between light and dark themes',
                                                ),
                                                value: isDark,
                                                onChanged:
                                                    (_) =>
                                                        themeProvider
                                                            .toggleTheme(),
                                              ),
                                              const Divider(height: 1),
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: const Text('Language'),
                                                subtitle: Text(
                                                  localeProvider
                                                              .locale
                                                              .languageCode ==
                                                          'en'
                                                      ? 'English (US)'
                                                      : 'हिन्दी (HI)',
                                                ),
                                                trailing: OutlinedButton.icon(
                                                  onPressed: () {
                                                    final newLocale =
                                                        localeProvider
                                                                    .locale
                                                                    .languageCode ==
                                                                'en'
                                                            ? const Locale('hi')
                                                            : const Locale(
                                                              'en',
                                                            );
                                                    localeProvider.setLocale(
                                                      newLocale,
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.language,
                                                    size: 18,
                                                  ),
                                                  label: const Text('Change'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 24),

                                        // Security Section
                                        ProfileSectionCard(
                                          title:
                                              loc?.translate('security') ??
                                              'Security',
                                          child: Column(
                                            children: [
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: const Icon(Icons.lock),
                                                title: const Text(
                                                  'Change password',
                                                ),
                                                subtitle: const Text(
                                                  'Update your account password',
                                                ),
                                                trailing: OutlinedButton(
                                                  onPressed: () {
                                                    // Navigate to password change flow
                                                  },
                                                  child: const Text('Update'),
                                                ),
                                              ),
                                              const Divider(height: 1),
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: const Icon(
                                                  Icons.logout,
                                                  color: Colors.red,
                                                ),
                                                title: const Text('Sign out'),
                                                subtitle: const Text(
                                                  'You will be asked to sign in again',
                                                ),
                                                trailing: OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                        foregroundColor:
                                                            Colors.red,
                                                        side: const BorderSide(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                  onPressed: () async {
                                                    await context
                                                        .read<AuthProvider>()
                                                        .signout();
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
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
          const Spacer(),
          Text(
            _editing ? 'Editing' : 'View only',
            style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _onUploadAvatar() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes(); // Works on Web + Mobile

        setState(() {
          final base64Image = base64Encode(bytes);
          Provider.of<AuthProvider>(context, listen: false)
              .updateAvatarBase64(base64Image);
        });
      }
    } catch (e) {}
  }

  Future<void> _onRemoveAvatar() async {
    Provider.of<AuthProvider>(context, listen: false)
        .updateAvatarBase64("");
  }
}
