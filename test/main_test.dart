import 'package:e_tutoring/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('main ...', (tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.byKey(ValueKey("title")), findsOneWidget);
  });

  testWidgets('MainPage is present and triggers navigation after tapped',
      (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: MyApp(),
        navigatorObservers: [mockObserver],
      ),
    );

    expect(find.byType(MainPage), findsOneWidget);
  });
}
