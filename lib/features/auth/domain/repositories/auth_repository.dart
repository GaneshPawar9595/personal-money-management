// Import the UserEntity which represents the user data structure used in the app
import '../entities/user_entity.dart';

// This is an abstract class that defines the basic actions related to user authentication
// It acts as a contract that any login system must follow, but it doesn't provide the actual implementation
abstract class AuthRepository {
  // This function is for registering a new user
  // It takes email, password, username, and phone as inputs
  // Returns the user information if the sign-up is successful, or null if it fails
  Future<UserEntity?> signUp(String email, String password, String username, String phone);

  // This function is for logging in an existing user
  // Takes email and password as inputs
  // Returns the user information if the login is successful, or null if it fails
  Future<UserEntity?> signIn(String email, String password);

  // This function signs the user out of the app
  // It doesn't return any data but completes the sign-out process
  Future<void> signOut();
}
