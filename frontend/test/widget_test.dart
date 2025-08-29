// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:edencompta_pos/app.dart';
import 'package:edencompta_pos/core/constants/app_constants.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter();
    await Hive.openBox(AppConstants.authBox);
    await Hive.openBox(AppConstants.settingsBox);
  });

  testWidgets('App should start without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: EdenComptaApp()));

    // Verify that the app loads
    await tester.pump();
    
    // App should not crash
    expect(tester.takeException(), isNull);
  });
}
