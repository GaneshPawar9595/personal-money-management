// Import Firebase Authentication package for user login and signup
import 'package:firebase_auth/firebase_auth.dart';

// Import Firebase Firestore package which is used to store user data
import 'package:cloud_firestore/cloud_firestore.dart';

// Import the user model which formats user data for the app
import '../models/user_model.dart';

class AuthRemoteDataSource {
  // Create instances to access Firebase Authentication and Firestore services
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Signs up a new user using email, password, username, and phone number
  /// It also saves this new user's info in the Firestore database under 'users'
  /// Signs up a new user and handles errors gracefully
  Future<UserModel?> signUp(String email, String password, String username, String phone) async {
    try {
      // Attempt to create a new user account with Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final userId = credential.user!.uid;

      // Prepare user data to save in Firestore
      final userModel = UserModel(
        id: userId,
        email: email,
        name: username,
        phone: phone,
        createdAt: DateTime.now().toIso8601String(),
      );

      // Save additional user data in Firestore
      await _firestore.collection('users').doc(userId).set(userModel.toJson());

      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  /// Signs in a user using email and password
  /// Then fetches user's additional data stored in Firestore
  Future<UserModel?> signIn(String email, String password) async {
    try {
      // Log in the user using Firebase Authentication
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final userId = credential.user!.uid; // Get the logged-in user's ID

      // Retrieve the user's data from Firestore 'users' collection using the userId
      final doc = await _firestore.collection('users').doc(userId).get();

      // If user data exists, convert it to UserModel and return it, otherwise return null
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      } else {
        return null;
      }
    }catch(e){
      rethrow;
    }
  }

  /// Provides a stream to listen for real-time updates to the current user's data in Firestore
  Stream<UserModel?> userDataStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      // Convert updated Firestore data into UserModel or return null if not found
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    });
  }

  /// Signs out the currently logged-in user from Firebase Authentication
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
