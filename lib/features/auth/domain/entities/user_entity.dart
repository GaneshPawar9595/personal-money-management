import 'dart:convert';
import 'dart:typed_data';

class UserEntity {
  /// Unique identifier of the user
  final String id;

  /// User's full name
  final String name;

  /// User's email address
  final String email;

  /// Optional phone number of the user
  final String? phone;

  /// Optional URL or path to the user's profile image
  final String? profileImage;

  /// Optional Firebase Cloud Messaging token for push notifications
  final String? fcmToken;

  /// Timestamp string indicating when the user was created (ISO 8601 format recommended)
  final String createdAt;

  /// Optional timestamp string indicating user's last login time
  final String? loginAt;

  /// Constructor for UserEntity with required and optional fields.
  /// All fields are immutable (final) to maintain consistency.
  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    this.fcmToken,
    required this.createdAt,
    this.loginAt,
  });

  /// If a profile picture is stored as Base64 text, this tries to turn it into real image bytes.
  /// - If it works, you get bytes that can be shown as a picture.
  /// - If it fails or there’s no image, it returns nothing. [web:100][web:104]
  Uint8List? get profileImageBytes {
    if (profileImage != null && profileImage!.isNotEmpty) {
      try {
        return base64Decode(profileImage!); // Tries to decode the picture text into image data. [web:100][web:104]
      } catch (_) {
        // If the text isn’t a valid Base64 image, just don’t return anything to avoid app errors. [web:101][web:104]
        return null;
      }
    }
    // No picture provided. [web:101][web:104]
    return null;
  }
}
