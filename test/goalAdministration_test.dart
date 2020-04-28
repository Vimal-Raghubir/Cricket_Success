import 'package:cricket_app/classes/goalInformation.dart';
import 'package:cricket_app/pages/createGoal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing Goal Form', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final customGoal = GoalInformation();
    await tester.pumpWidget(NewGoal(goal: customGoal));

    final titleFinder = find.text('What kind of goal would you like to create?');

    // Verify that our counter starts at 0.
    expect(titleFinder, findsWidgets);
    //await tester.pump();
  });
}
