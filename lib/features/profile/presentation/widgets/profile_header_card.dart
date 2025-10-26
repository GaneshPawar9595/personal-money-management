import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final Uint8List? photoUrl;
  final VoidCallback onUploadAvatar;
  final VoidCallback onRemoveAvatar;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.onUploadAvatar,
    required this.onRemoveAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: 40,
      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      backgroundImage:
          photoUrl != null && photoUrl!.isNotEmpty
              ? MemoryImage(photoUrl!)
              : null,
      child:
          (photoUrl == null || photoUrl!.isEmpty)
              ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
              : null,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                avatar,
                Material(
                  color: Theme.of(context).cardColor,
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip:
                        photoUrl == null || photoUrl!.isEmpty
                            ? 'Upload photo'
                            : 'Change photo',
                    icon: const Icon(Icons.camera_alt, size: 18),
                    onPressed: onUploadAvatar,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [_chip(context, Icons.verified_user, 'Verified')],
                  ),
                ],
              ),
            ),
            if (photoUrl != null && photoUrl!.isNotEmpty)
              OutlinedButton.icon(
                onPressed: onRemoveAvatar,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Remove'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, IconData icon, String label) {
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha:0.08),
      side: BorderSide(color: Theme.of(context).dividerColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
