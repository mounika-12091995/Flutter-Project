import 'package:Shubhvite/screens/authenticationpage/resetpassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:my_flutter_app/main.dart'; // Replace with your app's main.dart import

void main() {
  testWidgets('Reset Password integration test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget((resetpassword(mobilenumber: '7799895481',))); // Replace MyApp() with your app's root widget

    // Navigate to the Reset Password screen
    await tester.tap(find.text('Reset Password')); // Replace 'Reset Password' with your button or link text to navigate to reset password screen
    await tester.pumpAndSettle(); // Wait for animations to complete and UI to settle

    // Verify that we're on the Reset Password screen
    expect(find.text('Reset Password'), findsOneWidget); // Replace 'Reset Password' with your screen title or relevant UI element

    // Enter old password
    await tester.enterText(find.byKey(Key('oldPasswordField')), 'oldPassword123');

    // Enter new password
    await tester.enterText(find.byKey(Key('newPasswordField')), 'newPassword123');

    // Enter confirm password
    await tester.enterText(find.byKey(Key('confirmNewPasswordField')), 'newPassword123');

    // Tap the reset password button
    await tester.tap(find.text('Submit')); // Replace 'Reset' with your button text
    await tester.pumpAndSettle(); // Wait for animations to complete and UI to settle

    // Verify success message or navigate to another screen indicating success
    expect(find.text('Password reset successfully.'), findsOneWidget); // Example check for success message
  });
}
