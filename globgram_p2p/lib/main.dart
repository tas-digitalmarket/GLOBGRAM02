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
  await runAppWithFirebase();
}

Future<void> runAppWithFirebase() async {
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
      runApp(_buildErrorApp('Firebase initialization failed', firebaseError));
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
    runApp(_buildErrorApp('Application initialization failed', e));
  }
}

/// Build error app for any initialization failure
Widget _buildErrorApp(String context, Object error) {
  return MaterialApp(
    title: 'GlobGram P2P - Error',
    home: ErrorScreen(
      error: '$context:\n\n$error',
      onRetry: () async {
        await runAppWithFirebase();
      },
    ),
  );
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
