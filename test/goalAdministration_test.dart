import 'package:cricket_app/administration/goalManagement.dart';
import 'package:cricket_app/classes/goalInformation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cricket_app/main.dart';

void main() {
  testWidgets('Testing Goal Form', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final customGoal = GoalInformation();
    await tester.pumpWidget(GoalManagement(passedGoal: customGoal, type: 'new'));

    //await tester.enterText(find.byType(TextFormField), 'hello');

    final titleFinder = find.text('What kind of goal would you like to create?');

    // Verify that our counter starts at 0.
    expect(titleFinder, findsOneWidget);
    //await tester.pump();
  });
}
