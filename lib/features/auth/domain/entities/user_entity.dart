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

/// You can add helper methods here if needed, for example, to display formatted dates,
/// or to copy with modifications (copyWith), but keep entity logic minimal.
}
