// Import the UserEntity which represents the user data in the app
import '../entities/user_entity.dart';

// Import the AuthRepository that manages how users log in (like checking the username and password)
import '../repositories/auth_repository.dart';

// This class handles the "sign in" action — when an existing user logs into their account
class SignInUseCase {
  // 'repository' contains the logic to interact with backend systems or databases for signing in
  final AuthRepository repository;

  // When creating an instance of this class, we pass in the authentication repository
  SignInUseCase(this.repository);

  // This function actually performs the sign-in process by passing the user's email and password
  // It returns the user details if login is successful, or null if it fails
  Future<UserEntity?> execute(String email, String password) {
    return repository.signIn(email, password);
  }
}
