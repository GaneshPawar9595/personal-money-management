// Firebase Authentication for email/password auth and auth state stream. [web:27][web:30]
import 'package:firebase_auth/firebase_auth.dart'; // [web:27]

// Cloud Firestore for persisting user profiles and updates. [web:40][web:43]
import 'package:cloud_firestore/cloud_firestore.dart'; // [web:40][web:43]

// App-side user model (DTO <-> JSON) used for Firestore serialization. [web:40]
import '../models/user_model.dart'; // [web:40]

/// Remote data source that wraps Firebase Auth and Firestore user operations. [web:27]
class AuthRemoteDataSource {
  /// Auth singleton; inject via constructor in tests if needed. [web:27]
  final FirebaseAuth _auth;

  /// Firestore singleton; inject via constructor in tests if needed. [web:40]
  final FirebaseFirestore _firestore;

  /// Prefer injectable singletons for testability; default to instances. [web:27][web:40]
  AuthRemoteDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance; // [web:27][web:40]

  /// Emits the current user's uid on auth changes, or null when signed out. [web:27][web:34]
  Stream<String?> authStateStream() {
    return _auth.authStateChanges().map((u) => u?.uid); // [web:27][web:34]
  }

  /// Creates a user with email/password, persists profile in 'users/{uid}', and returns the model. [web:27][web:40]
  Future<UserModel?> signUp(
      String email,
      String password,
      String username,
      String phone,
      ) async {
    try {
      // Create Firebase account. [web:27]
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ); // [web:27]
      final user = credential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'No user returned after signUp.',
        ); // [web:27]
      }

      // Build initial profile. [web:40]
      final userModel = UserModel(
        id: user.uid,
        email: email,
        name: username,
        phone: phone,
        createdAt: DateTime.now().toIso8601String(),
      ); // [web:40]

      // Upsert profile at users/{uid}. [web:40][web:43]
      await _firestore.collection('users').doc(user.uid).set(userModel.toJson()); // [web:40][web:43]
      return userModel; // [web:40]
    } on FirebaseAuthException {
      // Preserve FirebaseAuth typed errors for UI mapping. [web:27]
      rethrow; // allowed by avoid_catches_without_on_clauses when rethrowing [web:33]
    } on FirebaseException {
      // Firestore operation failures (permissions/unavailable). [web:40]
      rethrow; // [web:33]
    }
  }

  /// Signs in with email/password, then loads the user's profile document. [web:27][web:40]
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ); // [web:27]
      final user = credential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'No user returned after signIn.',
        ); // [web:27]
      }

      // Fetch user profile from Firestore. [web:40]
      final doc = await _firestore.collection('users').doc(user.uid).get(); // [web:40]
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!); // [web:40]
      }
      return null; // [web:40]
    } on FirebaseAuthException {
      rethrow; // maintain typed context for UI [web:27][web:33]
    } on FirebaseException {
      rethrow; // Firestore specific errors [web:40][web:33]
    }
  }

  /// Real-time stream of the user's profile document mapped to UserModel. [web:40]
  Stream<UserModel?> userDataStream(String userId) {
    // Using auth uid as document id aligns with rules like: request.auth.uid == userId. [web:34][web:31]
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!); // [web:40]
      }
      return null; // [web:40]
    }); // [web:34]
  }

  /// Signs out the current user. [web:27]
  Future<void> signOut() async {
    await _auth.signOut(); // [web:27]
  }

  /// Updates profile fields (name/phone) with upsert semantics, then returns the latest model. [web:40][web:43]
  Future<UserModel?> updateProfile(
      String userId,
      String name,
      String phone,
      ) async {
    // Prepare partial updates; empty object is a no-op when set(..., merge:true). [web:43][web:35]
    final updates = <String, dynamic>{};
    if (name.isNotEmpty) updates['name'] = name; // [web:40]
    if (phone.isNotEmpty) updates['phone'] = phone; // [web:40]

    final ref = _firestore.collection('users').doc(userId); // [web:40]

    // Prefer set(..., merge:true) to create-or-update in one call. [web:43][web:32]
    await ref.set(updates, SetOptions(merge: true)); // [web:43][web:32]

    final snap = await ref.get(); // [web:40]
    if (!snap.exists || snap.data() == null) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
        message: 'User not found',
      ); // [web:40]
    }
    return UserModel.fromJson(snap.data()!); // [web:40]
  }

  /// Updates the avatar field with a base64 string and returns the latest model. [web:40]
  Future<UserModel?> updateAvatarBase64(
      String userId,
      String base64Image,
      ) async {
    // Update the profileImage field; security rules should restrict to owner. [web:34][web:40]
    final ref = _firestore.collection('users').doc(userId); // [web:40]
    await ref.update({'profileImage': base64Image}); // [web:40]

    final snap = await ref.get(); // [web:40]
    if (!snap.exists || snap.data() == null) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
        message: 'User not found',
      ); // [web:40]
    }
    return UserModel.fromJson(snap.data()!); // [web:40]
  }

  /// Retrieves a user's profile by id, or null if absent. [web:40]
  Future<UserModel?> getProfile(String userId) async {
    final snap = await _firestore.collection('users').doc(userId).get(); // [web:40]
    if (!snap.exists || snap.data() == null) return null; // [web:40]
    return UserModel.fromJson(snap.data()!); // [web:40]
  }
}
