import 'package:Shubhvite/screens/authenticationpage/login_page_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:Shubhvite/screens/authenticationpage/loginpage.dart'; // Update this import with the correct path to your main file

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login form test', (WidgetTester tester) async {
    // Launch the app
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginPage())));

    // Find email and password fields and submit button
    final emailField = find.byKey(Key('emailField'));
    final passwordField = find.byKey(Key('passwordField'));
    final submitButton = find.byKey(Key('submitButton'));

    // Verify if the email and password fields and submit button are present
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(submitButton, findsOneWidget);

    // Enter text into the email and password fields
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');

    // Tap the submit button
    await tester.tap(submitButton);

    // Allow the app to process the inputs
    await tester.pumpAndSettle();

    // Verify if a success message is shown
    expect(find.text('Processing Data'), findsOneWidget);
  });
}
