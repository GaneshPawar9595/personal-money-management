// Import GetIt package, which helps manage and provide dependencies throughout the app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

// Import various files related to authentication features
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/provider/auth_provider.dart';

// For category
import '../../features/category/data/datasources/category_remote_datasource.dart';
import '../../features/category/data/datasources/category_remote_datasource_impl.dart';
import '../../features/category/data/repositories/category_repository_impl.dart';
import '../../features/category/domain/repositories/category_repository.dart';
import '../../features/category/domain/usecases/add_category_usecase.dart';
import '../../features/category/domain/usecases/add_default_dategories.dart';
import '../../features/category/domain/usecases/delete_category_usecase.dart';
import '../../features/category/domain/usecases/get_categories_usecase.dart';
import '../../features/category/domain/usecases/update_category_usecase.dart';
import '../../features/category/presentation/provider/category_provider.dart';
import '../../features/transaction/data/datasources/transaction_remote_datasource.dart';
import '../../features/transaction/data/datasources/transaction_remote_datasource_imp.dart';
import '../../features/transaction/data/repositories/transaction_repository_impl.dart';
import '../../features/transaction/domain/repositories/transaction_repository.dart';
import '../../features/transaction/domain/usecases/add_transaction_usecase.dart';
import '../../features/transaction/domain/usecases/delete_transaction_usecase.dart';
import '../../features/transaction/domain/usecases/get_transaction_usecase.dart';
import '../../features/transaction/domain/usecases/update_transaction_usecase.dart';
import '../../features/transaction/presentation/provider/transaction_provider.dart';

// Create a single shared instance of GetIt for managing dependencies
final GetIt locator = GetIt.instance;

// Call this function once when the app starts to register and prepare all dependencies
void setupLocator() {
  // Register FirebaseFirestore instance if not registered yet
  locator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Login & Register
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

  // Category registrations
  // Register Firestore remote data source implementation
  locator.registerLazySingleton<CategoryRemoteDataSource>(() => CategoryRemoteDataSourceImpl(locator()));

  // Register Category repository implementation
  locator.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(locator()));

  // Register category use cases
  locator.registerLazySingleton<AddCategoryUseCase>(() => AddCategoryUseCase(locator()));
  locator.registerLazySingleton<GetCategoriesUseCase>(() => GetCategoriesUseCase(locator()));
  locator.registerLazySingleton<UpdateCategoryUseCase>(() => UpdateCategoryUseCase(locator()));
  locator.registerLazySingleton<DeleteCategoryUseCase>(() => DeleteCategoryUseCase(locator()));
  locator.registerLazySingleton<AddDefaultCategoriesUseCase>(() => AddDefaultCategoriesUseCase(locator()));

  // Register CategoryProvider as a factory to get fresh instances with DI
  locator.registerLazySingleton<CategoryProvider>(() => CategoryProvider(
    addCategoryUseCase: locator(),
    getCategoriesUseCase: locator(),
    updateCategoryUseCase: locator(),
    deleteCategoryUseCase: locator(),
    addDefaultCategoriesUseCase: locator(),
  ));

  // Transaction registrations
  // Register Firestore remote data source implementation
  locator.registerLazySingleton<TransactionRemoteDatasource>(() => TransactionRemoteDataSourceImpl(locator()));

  // Register Category repository implementation
  locator.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(locator()));

  // Register category use cases
  locator.registerLazySingleton<AddTransactionUseCase>(() => AddTransactionUseCase(locator()));
  locator.registerLazySingleton<GetTransactionUseCase>(() => GetTransactionUseCase(locator()));
  locator.registerLazySingleton<UpdateTransactionUseCase>(() => UpdateTransactionUseCase(locator()));
  locator.registerLazySingleton<DeleteTransactionUseCase>(() => DeleteTransactionUseCase(locator()));

  // Register CategoryProvider as a factory to get fresh instances with DI
  locator.registerLazySingleton<TransactionProvider>(() => TransactionProvider(
    addTransactionUseCase: locator(),
    getTransactionUseCase: locator(),
    updateTransactionUseCase: locator(),
    deleteTransactionUseCase: locator(),
  ));
}
