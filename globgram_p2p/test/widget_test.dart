// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:globgram_p2p/main.dart';

void main() {
  testWidgets('GlobGram app smoke test', (WidgetTester tester) async {
    // Initialize EasyLocalization for testing
    await EasyLocalization.ensureInitialized();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const GlobgramApp(),
      ),
    );
    
    // Let the app settle
    await tester.pumpAndSettle();

    // Verify that we have the welcome text
    expect(find.text('Welcome to GlobGram P2P'), findsOneWidget);
  });
}
