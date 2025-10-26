import 'dart:async';

import 'package:flutter/material.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/observe_auth_state_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/update_avatar_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

/// This provider manages the authentication state for the app,
/// handling user sign-up and sign-in processes by communicating with the domain use cases.
/// It exposes loading and error states so the UI can react accordingly,
/// and holds the currently authenticated user entity.
class AuthProvider extends ChangeNotifier {
  /// Use case handling user registration flow.
  final SignUpUseCase signUpUseCase;

  /// Use case handling user login flow.
  final SignInUseCase signInUseCase;
  final ObserveAuthStateUsecase observeAuthState;
  final UpdateProfileUsecase updateProfileUsecase;
  final UpdateAvatarUsecase updateAvatarUsecase;
  final SignOutUsecase signOutUsecase;
  final GetProfileUsecase getProfileUsecase;

  /// Holds the currently authenticated user.
  UserEntity? _user;
  UserEntity? get user => _user;

  /// Indicates if an authentication operation is in progress.
  bool _loading = false;
  bool get loading => _loading;

  /// Starts listening for login status changes as soon as this helper is created.
  AuthProvider({
    required this.observeAuthState,
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.updateProfileUsecase,
    required this.updateAvatarUsecase,
    required this.signOutUsecase,
    required this.getProfileUsecase,
  }) {
    _sub = observeAuthState().listen(_onUid);
  }

  /// Keeps a “subscription,” which is like a phone line that stays open for updates. [web:101][web:104]
  StreamSubscription<String?>? _sub;

  /// Listens for login changes:
  /// - If there’s an ID, fetch full details.
  /// - If not, clear everything because no one is logged in. [web:101][web:104]
  Future<void> _onUid(String? uid) async {
    _setLoading(true);
    try {
      if (uid == null) {
        _clearState(); // No one is logged in now.
        return;
      }
      // Someone is logged in — fetch their latest details.
      final full = await getProfileUsecase(userId: uid); // see helper below or use a dedicated GetProfileUsecase if you added it
      if (full != null) {
        _user = full;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Auth state error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Updates the loading state and informs listeners (the UI).
  void _setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  /// Clears the current person and any session info when logging out.
  void _clearState() {
    _user = null;
    notifyListeners();
  }

  /// Processes user sign-up with provided credentials.
  ///
  /// Shows loading indicator while ongoing,
  /// catches errors and sets user or error messages accordingly,
  /// and informs UI of all state changes.
  Future<void> signUp(
    String email,
    String password,
    String username,
    String phone,
  ) async {
    try {
      _setLoading(true);

      // Run domain sign-up use case
      final userEntity = await signUpUseCase.execute(
        email,
        password,
        username,
        phone,
      );

      if (userEntity != null) {
        // Successfully signed up
        _user = userEntity;
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Processes user sign-in with provided email and password.
  ///
  /// Shows a loading indicator during authentication,
  /// catches errors from Firebase and sets appropriate error messages,
  /// and updates the authenticated user entity if successful.
  Future<void> signIn(String email, String password) async {
    try {
      _setLoading(true);

      final userEntity = await signInUseCase.execute(email, password);

      if (userEntity != null) {
        _user = userEntity;
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Logs the person out so the app knows they’re not signed in anymore.
  Future<void> signout() async {
    _setLoading(true); // Show that we’re doing work.
    try {
      await signOutUsecase.call(); // Ask the logout tool to do the job.
      _clearState(); // Forget the current person after sign‑out.
    } finally {
      _setLoading(false); // Done with sign‑out.
    }
  }

  /// Updates the person’s name and phone number, and then saves the new details.
  Future<void> updateProfile(String name, String phone) async {
    final u = user; // The person who’s logged in now.
    if (u == null) return;  // If no one is logged in, there’s nothing to update.
    _setLoading(true);
    try {
      final userEntity = await updateProfileUsecase(u.id, name, phone); // Ask to save the new info.
      if (userEntity != null) {
        _user = userEntity; // Keep the latest details.
      }
    } catch (e) {
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false); // Done with the update.
    }
  }

  /// Updates the person’s profile photo, and then saves the new details.
  Future<void> updateAvatarBase64(String base64Image) async {
    final u = user; // Who we’re updating.
    if (u == null) return; // Can’t update if no one is logged in.
    _setLoading(true);
    try {
      final userEntity = await updateAvatarUsecase(u.id, base64Image); // Ask to save the new photo.
      if (userEntity != null) {
        _user = userEntity; // Keep the latest details.
      }
    } catch (e) {
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false); // Done with the update.
    }
  }

  @override
  void dispose() {
    _sub?.cancel(); // Stop listening when this helper is no longer used. [web:101][web:104]
    super.dispose(); // Finish cleanup. [web:101][web:104]
  }
}
