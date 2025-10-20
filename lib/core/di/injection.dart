// Import GetIt package, which helps manage and provide dependencies throughout the app
import 'package:get_it/get_it.dart';

// Import various files related to authentication features
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/provider/auth_provider.dart';

// Create a single shared instance of GetIt for managing dependencies
final GetIt locator = GetIt.instance;

// Call this function once when the app starts to register and prepare all dependencies
void setupLocator() {
  // Register the remote data source that talks to Firebase for authentication
  locator.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());

  // Register the repository that manages authentication by using the remote data source
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(locator()));

  // Register the use case for user sign-up that depends on the repository
  locator.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(locator()));

  // Register the use case for user sign-in that also depends on the repository
  locator.registerLazySingleton<SignInUseCase>(() => SignInUseCase(locator()));

  // Register the AuthProvider which provides state management for authentication in the UI;
  // this one creates a fresh instance every time it's requested
  locator.registerFactory<AuthProvider>(() => AuthProvider(
    signUpUseCase: locator(),
    signInUseCase: locator(),
  ));
}
