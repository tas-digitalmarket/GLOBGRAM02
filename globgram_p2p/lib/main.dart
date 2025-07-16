import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:globgram_p2p/core/app_router.dart';
import 'package:globgram_p2p/core/app_theme.dart';
import 'package:globgram_p2p/core/service_locator.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Logger().i('[✅] Firebase initialized successfully');
  } catch (e) {
    Logger().e('[❌] Firebase initialization failed: $e');
  }

  // Initialize HydratedBloc storage
  if (kIsWeb) {
    // For web, use a simple storage implementation
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorage.webStorageDirectory,
    );
  } else {
    // For mobile platforms, we would use path_provider
    // But since we're focusing on web, this branch is not needed for now
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorage.webStorageDirectory,
    );
  }

  await setupServiceLocator();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
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
