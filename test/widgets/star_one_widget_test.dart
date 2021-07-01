import 'package:e_tutoring/widgets/star_one_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget getStarOneWidget() {
  return Directionality(
    child: MediaQuery(
      data: MediaQueryData(),
      child: StarOneWidget(star: 5, pre: false, post: true),
    ),
    textDirection: TextDirection.ltr,
  );
}

void main() {
  testWidgets('StarOneWidget', (WidgetTester tester) async {
    await tester.pumpWidget(getStarOneWidget());
  });
}
