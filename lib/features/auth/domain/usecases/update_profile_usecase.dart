import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

/// This helper updates a person’s basic details (like their name or phone number)
/// and then gives back the latest user info after the change.
class UpdateProfileUsecase {
  /// Where we send the request to change the user’s info and get the updated details.
  final AuthRepository repo;

  /// Remembers which place (repo) to use for making the update.
  UpdateProfileUsecase(this.repo);

  /// Runs the “update profile” action:
  /// - userId: who we’re changing
  /// - name and phone: the new details to save
  /// Returns the updated user details, or nothing if the update didn’t happen.
  Future<UserEntity?> call(String userId, String name, String phone) {
    return repo.updateProfile(userId, name, phone); // Asks the repository to do the actual update.
  }
}
