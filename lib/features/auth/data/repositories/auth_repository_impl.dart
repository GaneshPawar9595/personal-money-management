// Import the UserEntity which holds user information
import '../../domain/entities/user_entity.dart';

// Import the abstract AuthRepository which defines the methods for authentication
import '../../domain/repositories/auth_repository.dart';

// Import the data source that actually talks to the backend server or service
import '../datasources/auth_remote_datasource.dart';

// This class "implements" the AuthRepository, meaning it provides the real actions for login, signup, and logout
class AuthRepositoryImpl implements AuthRepository {
  // The data source that connects to the backend (like a server or Firebase)
  final AuthRemoteDataSource remoteDataSource;

  // When creating this repository, we provide it with the remote data source
  AuthRepositoryImpl(this.remoteDataSource);

  // Register a new user by calling the remote server's signup function with user details
  @override
  Future<UserEntity?> signUp(String email, String password, String username, String phone) {
    return remoteDataSource.signUp(email, password, username, phone);
  }

  // Log in an existing user by calling the remote server's signin function with email and password
  @override
  Future<UserEntity?> signIn(String email, String password) {
    return remoteDataSource.signIn(email, password);
  }

  // Log the user out by calling the remote server's signout function
  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }
}
