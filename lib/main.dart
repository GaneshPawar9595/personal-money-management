import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:money_management/shared/provider/locale_provider.dart';
import 'package:money_management/shared/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'config/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'router.dart';
import '../features/auth/presentation/provider/auth_provider.dart';
import '../core/di/injection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // This ensures Flutter framework is ready before we do any initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (cloud backend for authentication, database, etc.)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Setup Dependency Injection
  // This allows the app to easily get instances of classes (like AuthProvider)
  setupLocator();

  // Wrap the app with multiple providers (state management)
  // Providers are like global variables that widgets can listen to
  runApp(
    MultiProvider(
      providers: [
        // Provider for managing app's theme (light/dark mode)
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // Provider for managing app's language (locale)
        ChangeNotifierProvider(create: (_) => LocaleProvider()),

        // Provider for authentication logic (login/signup)
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => GetIt.instance<AuthProvider>(),
        ),
      ],
      child: const MyApp(), // The main app widget
    ),
  );
}

// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current theme and language from the providers
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    // MaterialApp.router is the main app container
    return MaterialApp.router(
      title: 'Money Management App',        // App name
      routerConfig: router,                 // Handles page navigation (using GoRouter)
      debugShowCheckedModeBanner: false,   // Hides the debug banner in the app
      theme: AppTheme.lightTheme,          // Light theme design
      darkTheme: AppTheme.darkTheme,       // Dark theme design
      themeMode: themeProvider.themeMode,  // Switch between light/dark mode
      locale: localeProvider.locale,       // Current language of the app

      // List of languages the app supports
      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'), // Hindi
      ],

      // Delegates to load translations and material widgets for localization
      localizationsDelegates: const [
        AppLocalizations.delegate,           // Your custom translations
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
