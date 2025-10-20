// Import the UserEntity which holds the basic user data structure
import '../../domain/entities/user_entity.dart';

// UserModel extends UserEntity, meaning it adds extra functions on top of basic user info
class UserModel extends UserEntity {
  // Constructor to create a UserModel object
  // It requires some information (id, name, email, created date)
  // and some other info is optional (phone, profile image, login time, etc.)
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.profileImage,
    super.fcmToken,
    required super.createdAt,
    super.loginAt,
  });

  // A special function to create a UserModel from data received (in JSON format)
  // JSON is often how data is sent between app and server; this converts it into a usable UserModel object
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '', // Take 'id' from JSON or use empty if missing
    name: json['name'] ?? '', // Take 'name' or default to empty
    email: json['email'] ?? '', // Take 'email' or default to empty
    phone: json['phone'], // Phone can be null, so no default here
    profileImage: json['profileImage'], // Optional profile picture URL or data
    fcmToken: json['fcmToken'], // For push notifications, can be empty
    createdAt: json['createdAt'] ?? '', // Date user was created
    loginAt: json['loginAt'], // Last login time, optional
  );

  // This function turns the UserModel data back into JSON format
  // This is useful to send data back to a server or save it in a file
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'profileImage': profileImage,
    'fcmToken': fcmToken,
    'createdAt': createdAt,
    'loginAt': loginAt,
  };
}
