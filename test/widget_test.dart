// Basic Flutter widget test for MARVIZ AI.
//
// This test verifies that the app boots without errors and the
// splash screen shows the MARVIZ AI brand name.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:marviz_ai/main.dart';

void main() {
  testWidgets('MARVIZ AI app boots and shows splash logo', (WidgetTester tester) async {
    // Build the app wrapped in ProviderScope (required for Riverpod).
    await tester.pumpWidget(
      const ProviderScope(
        child: MarvizApp(),
      ),
    );

    // Pump once to render the first frame (splash screen).
    await tester.pump();

    // Verify that the brand name is visible on the splash screen.
    expect(find.text('MARVIZ AI'), findsOneWidget);

    // Let all pending timers and animations complete so the test
    // tears down cleanly. This drains:
    // - The splash screen's animation controller
    // - The 500ms simulated auth check
    // - The 2s splash duration delay
    // - Any router transition timers
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}