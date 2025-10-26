import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

/// This helper updates a person’s profile photo using a text version of the image (Base64),
/// then gives back the person’s latest details after the change.
class UpdateAvatarUsecase {
  /// Where we send the request to change the photo and get the updated user info.
  final AuthRepository repo;

  /// Remembers which place (repo) to use for making the update.
  UpdateAvatarUsecase(this.repo);

  /// Runs the “update photo” action:
  /// - userId: who we’re changing the photo for
  /// - base64Image: the picture, saved as text (Base64)
  /// Returns the updated user details, or nothing if the update didn’t happen.
  Future<UserEntity?> call(
      String userId,
      String base64Image,
      ) {
    return repo.updateAvatarBase64(userId, base64Image); // Asks the repository to do the actual update.
  }
}