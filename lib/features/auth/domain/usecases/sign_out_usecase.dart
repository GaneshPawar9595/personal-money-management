import '../repositories/auth_repository.dart';

/// This small helper handles the action of logging a person out of the app,
/// so the app knows they’re no longer signed in.
class SignOutUsecase {
  /// The place we call to perform user actions such as sign out.
  final AuthRepository repo;

  /// Creates this helper and remembers where to send the sign‑out request.
  SignOutUsecase(this.repo);

  /// Runs the sign‑out action; it doesn’t return any user data,
  /// it just completes the process of logging the person out.
  Future<void> call() {
    return repo.signOut();
  }
}
