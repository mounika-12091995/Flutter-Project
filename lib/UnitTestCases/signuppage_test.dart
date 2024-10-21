import 'package:Shubhvite/screens/authenticationpage/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Registration form validation test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpPage()));

    // Verify that form elements are present
    expect(find.byType(TextFormField), findsNWidgets(7));
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Enter valid data
    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
    await tester.enterText(find.byType(TextFormField).at(2), 'Middle');
    await tester.enterText(find.byType(TextFormField).at(3), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(4), '1234567890');
    await tester.enterText(find.byType(TextFormField).at(5), 'password');
    await tester.enterText(find.byType(TextFormField).at(6), 'password');

    // Tap the register button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that no validation errors are shown
    expect(find.text('Please enter your first name'), findsNothing);
    expect(find.text('Please enter your last name'), findsNothing);
    expect(find.text('Please enter your email address'), findsNothing);
    expect(find.text('Please enter a valid email address'), findsNothing);
    expect(find.text('Please enter your phone number'), findsNothing);
    expect(find.text('Please enter a valid 10-digit phone number'), findsNothing);
    expect(find.text('Please enter your password'), findsNothing);
    expect(find.text('Password must be at least 6 characters long'), findsNothing);
    expect(find.text('Please confirm your password'), findsNothing);
    expect(find.text('Passwords do not match'), findsNothing);
  });
}
