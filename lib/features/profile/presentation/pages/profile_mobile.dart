import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/provider/locale_provider.dart';
import '../../../../shared/provider/theme_provider.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_field_tile.dart';

class ProfileMobilePage extends StatefulWidget {
  const ProfileMobilePage({super.key});

  @override
  State<ProfileMobilePage> createState() => _ProfileMobilePageState();
}

class _ProfileMobilePageState extends State<ProfileMobilePage> {
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
        _nameCtrl.text = user.name ;
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
    final updatedName = _nameCtrl.text.trim();
    final updatedPhone = _phoneCtrl.text.trim();

    try {
      await auth.updateProfile(updatedName, updatedPhone);
      if (!mounted) return;
      setState(() => _editing = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update profile')));
    }
  }

  Future<void> _onUploadAvatar() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes(); // Works on Web + Mobile
        setState(() {
          final base64Image = base64Encode(bytes);
          Provider.of<AuthProvider>(
            context,
            listen: false,
          ).updateAvatarBase64(base64Image);
        });
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Avatar updated')));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to upload avatar')));
    }
  }

  Widget _buildTopBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop(); // or Navigator.pop(context);
            },
          ),
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

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
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
            child: SafeArea(
              child: _buildTopBar(),
            ), // now pinned at the top, outside scroll
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header block with larger avatar and actions
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Hero(
                                tag: "profileImage",
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child:
                                      (auth.user?.profileImageBytes != null &&
                                              auth
                                                  .user!
                                                  .profileImageBytes!
                                                  .isNotEmpty)
                                          ? Image.memory(
                                            auth.user!.profileImageBytes!,
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                            gaplessPlayback: true,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                                      width: 72,
                                                      height: 72,
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                      child: const Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                          )
                                          : Container(
                                            width: 72,
                                            height: 72,
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                                ),
                              ),

                              Material(
                                color: Theme.of(context).cardColor,
                                shape: const CircleBorder(),
                                child: IconButton(
                                  tooltip:
                                      auth.user?.profileImageBytes == null ||
                                              auth
                                                  .user!
                                                  .profileImageBytes!
                                                  .isNotEmpty
                                          ? 'Upload photo'
                                          : 'Change photo',
                                  icon: const Icon(Icons.camera_alt, size: 18),
                                  onPressed: _onUploadAvatar,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _nameCtrl.text.isEmpty
                                      ? (user.name)
                                      : _nameCtrl.text,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _emailCtrl.text.isEmpty
                                      ? (user.email)
                                      : _emailCtrl.text,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Personal info
                  ProfileSectionCard(
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
                  ),
                  const SizedBox(height: 16),

                  // Preferences
                  ProfileSectionCard(
                    title: 'Preferences',
                    child: Column(
                      children: [
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Dark Mode'),
                          subtitle: const Text(
                            'Switch between light and dark themes',
                          ),
                          value:
                              Theme.of(context).brightness == Brightness.dark,
                          onChanged:
                              (_) =>
                                  context.read<ThemeProvider>().toggleTheme(),
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

                  // Security
                  ProfileSectionCard(
                    title: 'Security',
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.lock),
                          title: const Text('Change password'),
                          subtitle: const Text('Update your account password'),
                          trailing: OutlinedButton(
                            onPressed: () {},
                            child: const Text('Update'),
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Sign out'),
                          subtitle: const Text(
                            'You will be asked to sign in again',
                          ),
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
