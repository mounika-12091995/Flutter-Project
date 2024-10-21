import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Shubhvite/screens/authenticationpage/loginpage.dart';  // Update with the correct path to your LoginForm

void main() {
  testWidgets('LoginForm has email and password fields and submit button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginPage())));

    // Find email and password fields
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

    // Find submit button
    expect(find.widgetWithText(ElevatedButton, 'Submit'), findsOneWidget);
  });

  testWidgets('Empty email and password shows error messages', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginPage())));

    // Tap the submit button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pump();

    // Check for error messages
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Valid email and password shows success message', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginPage())));

    // Enter valid email and password
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'maheshyala@gmail.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'Veera@934769');

    // Tap the submit button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pump();

    // Check for success message
    expect(find.text('Processing Data'), findsOneWidget);
  });
}
