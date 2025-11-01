// Provides the domain-level user model used across layers. [web:14]
import '../../domain/entities/user_entity.dart'; // [web:14]

// Declares the contract for authentication operations at the domain layer. [web:14]
import '../../domain/repositories/auth_repository.dart'; // [web:14]

// Implements actual network/service calls for auth operations. [web:14]
import '../datasources/auth_remote_datasource.dart'; // [web:14]

/// Concrete implementation of AuthRepository that delegates to a remote data source. [web:14]
class AuthRepositoryImpl implements AuthRepository {
  /// Remote source responsible for talking to backend or Firebase. [web:14]
  final AuthRemoteDataSource remoteDataSource; // prefer final when not reassigned [web:13][web:16]

  /// Inject the remote data source (use DI like get_it/Riverpod for testability). [web:14]
  AuthRepositoryImpl(this.remoteDataSource); // [web:14]

  /// Registers a new user with the backend and returns the created user, or null on failure. [web:14]
  @override
  Future<UserEntity?> signUp(
      String email,
      String password,
      String username,
      String phone,
      ) {
    // Pass-through to remote layer; consider mapping DTOs to entities here if needed. [web:14]
    return remoteDataSource.signUp(email, password, username, phone); // [web:14]
  }

  /// Signs in an existing user using email and password, returns user or null on failure. [web:14]
  @override
  Future<UserEntity?> signIn(String email, String password) {
    return remoteDataSource.signIn(email, password); // [web:14]
  }

  /// Signs out the current user. [web:14]
  @override
  Future<void> signOut() {
    return remoteDataSource.signOut(); // [web:14]
  }

  /// Updates user profile fields and returns the updated user, or null on failure. [web:14]
  @override
  Future<UserEntity?> updateProfile(String userId, String name, String phone) {
    return remoteDataSource.updateProfile(userId, name, phone); // [web:14]
  }

  /// Updates the avatar image using a Base64 string and returns the updated user, or null. [web:14]
  @override
  Future<UserEntity?> updateAvatarBase64(String userId, String base64Image) {
    return remoteDataSource.updateAvatarBase64(userId, base64Image); // [web:14]
  }

  /// Emits authentication state changes as a stream of userId or null. [web:12][web:14]
  @override
  String? getCurrentUserId() => remoteDataSource.getCurrentUserId(); // [web:12][web:14]

  /// Fetches the latest profile for the given userId. [web:14]
  @override
  Future<UserEntity?> getProfile({required String userId}) {
    return remoteDataSource.getProfile(userId); // [web:14]
  }
}
