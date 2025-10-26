import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// This small helper class asks the login system to fetch a person’s latest details
/// when given their unique user ID. Think of it as a “get user info by ID” button.
class GetProfileUsecase {
  /// The place we go to for user-related actions (sign in, get profile, etc.).
  final AuthRepository repo;

  /// Creates this helper and remembers where to ask for user data.
  GetProfileUsecase(this.repo);

  /// When you run this function with a userId, it asks for that person’s details
  /// and gives them back if found (or nothing if not found).
  Future<UserEntity?> call({required String userId}) {
    return repo.getProfile(userId: userId);
  }
}
