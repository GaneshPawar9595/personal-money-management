import '../repositories/auth_repository.dart';

/// This helper watches the app’s login status in real time,
/// so the app knows if someone is logged in or logged out.
class GetCurrentUserId {
  /// Where we ask about login status and other user actions.
  final AuthRepository repo;

  /// Remembers which place (repo) to ask for updates.
  GetCurrentUserId(this.repo);

  /// When you run this, it gives a stream of updates:
  /// it sends the person’s ID when they’re logged in, or nothing (null) when logged out.
  String? call() => repo.getCurrentUserId();
}