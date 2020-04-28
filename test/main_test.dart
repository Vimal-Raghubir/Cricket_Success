// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:cricket_app/main.dart';

void main() {
  testWidgets('Testing Main Page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyHomePage(title: 'MyCricketCompanion'));

    //final titleFinder = find.text('Please select a page below that you would like to navigate to');

    // Verify that our counter starts at 0.
    //expect(titleFinder, findsOneWidget);
    //await tester.pump();
  });
}
