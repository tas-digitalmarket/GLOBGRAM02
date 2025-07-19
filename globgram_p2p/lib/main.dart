import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/core/app_router.dart';
import 'package:globgram_p2p/core/app_theme.dart';
import 'package:globgram_p2p/core/service_locator.dart';
import 'package:globgram_p2p/core/presentation/error_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize EasyLocalization
    await EasyLocalization.ensureInitialized();

    // Initialize Firebase with try/catch
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      Logger().i('[✅] Firebase initialized successfully');
    } catch (firebaseError, stackTrace) {
      debugPrint('[❌] Firebase initialization failed: $firebaseError');
      debugPrint('Stack trace: $stackTrace');
      
      // Show error screen for Firebase failure
      runApp(_buildFirebaseErrorApp(firebaseError.toString()));
      return;
    }

    // Initialize HydratedBloc storage
    if (kIsWeb) {
      // For web platform
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorage.webStorageDirectory,
      );
    } else {
      // For mobile platforms
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorage.webStorageDirectory,
      );
    }
    Logger().i('[✅] HydratedBloc storage initialized');

    // Setup dependency injection
    await setupServiceLocator();
    Logger().i('[✅] Service locator initialized');

    // Run the application
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    Logger().e('[❌] Application initialization failed: $e');
    Logger().e('Stack trace: $stackTrace');
    debugPrint('[❌] Application initialization failed: $e');
    debugPrint('Stack trace: $stackTrace');
    
    // Run fallback error app
    runApp(_buildErrorApp(e.toString()));
  }
}

/// Build Firebase error app when Firebase initialization fails
Widget _buildFirebaseErrorApp(String error) {
  return MaterialApp(
    title: 'GlobGram P2P - Firebase Error',
    home: ErrorScreen(
      error: 'Firebase initialization failed:\n\n$error',
      onRetry: () async {
        // Trigger retry by calling main again
        await _retryInitialization();
      },
    ),
  );
}

/// Build general error app when other initialization fails
Widget _buildErrorApp(String error) {
  return MaterialApp(
    title: 'GlobGram P2P - Error',
    home: ErrorScreen(
      error: 'Application initialization failed:\n\n$error',
      onRetry: () async {
        // Trigger retry by calling main again
        await _retryInitialization();
      },
    ),
  );
}

/// Retry initialization by calling main again
Future<void> _retryInitialization() async {
  try {
    main();
  } catch (e) {
    debugPrint('[❌] Retry failed: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GlobGram P2P',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: appRouter,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
    );
  }
}
