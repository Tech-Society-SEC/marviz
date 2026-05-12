// Basic Flutter widget test for MARVIZ AI.
//
// This test verifies that the app builds correctly and displays
// the brand name. We'll expand this as features are added.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:marviz_ai/main.dart';

void main() {
  testWidgets('MARVIZ AI app loads and shows brand name', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope (required for Riverpod).
    await tester.pumpWidget(
      const ProviderScope(
        child: MarvizApp(),
      ),
    );

    // Verify that the brand name is shown.
    expect(find.text('MARVIZ AI'), findsOneWidget);

    // Verify that the tagline is shown.
    expect(find.text('Ride Smarter. Ride Safer.'), findsOneWidget);
  });
}