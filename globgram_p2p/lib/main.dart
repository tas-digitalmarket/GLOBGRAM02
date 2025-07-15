import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/app_router.dart';
import 'core/app_theme.dart';
import 'core/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  // TODO: Initialize HydratedBloc storage later
  // For now, skip HydratedBloc to get basic app running
  
  await setupServiceLocator();            // رجیستر سرویس‌ها (فعلاً خالی)
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const GlobgramApp(),
    ),
  );
}

class GlobgramApp extends StatelessWidget {
  const GlobgramApp({super.key});

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
