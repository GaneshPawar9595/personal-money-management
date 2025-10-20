// Import the UserEntity which represents the user data structure in the app
import '../entities/user_entity.dart';

// Import the AuthRepository that actually handles how users are registered (e.g., connecting to a server or database)
import '../repositories/auth_repository.dart';

// This class handles the "sign up" action — when a new user creates an account
class SignUpUseCase {
  // 'repository' is where the logic for communicating with the backend (like APIs or databases) lives
  final AuthRepository repository;

  // When creating an instance of this class, we pass in the authentication repository
  SignUpUseCase(this.repository);

  // This function performs the actual sign-up process
  // It takes user input (email, password, username, phone)
  // and passes it to the repository to register the new user
  Future<UserEntity?> execute(String email, String password, String username, String phone) {
    return repository.signUp(email, password, username, phone);
  }
}
