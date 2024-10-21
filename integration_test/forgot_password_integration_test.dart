import 'package:Shubhvite/screens/authenticationpage/forgotpassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/main.dart'; // Replace with your app's main.dart import

void main() {
  testWidgets('Forgot Password integration test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: forgotpassword()))); // Replace MyApp() with your app's root widget

    // Navigate to the Forgot Password screen
    await tester.tap(find.text('Forgot Password'));
    await tester.pumpAndSettle(); // Wait for animations to complete and UI to settle

    // Verify that we're on the Forgot Password screen
    expect(find.text('Forgot Password'), findsOneWidget);

    // Enter email address
    await tester.enterText(find.byType(TextField), 'gajula.veeraswamy1@gmail.com');

    // Tap the reset password button
    await tester.tap(find.text('Reset Password'));
    await tester.pumpAndSettle(); // Wait for animations to complete and UI to settle

    // Verify success message or navigate to another screen indicating success
    expect(find.text('Password reset instructions sent to your email.'), findsOneWidget);
  });
}
