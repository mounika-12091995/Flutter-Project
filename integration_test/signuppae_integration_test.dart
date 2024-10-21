import 'package:Shubhvite/screens/authenticationpage/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
//import 'package:your_project/main.dart' as app; // Adjust this import as necessary

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Register Form Integration Test', () {
    testWidgets('register form test', (WidgetTester tester) async {
      app.main();
await tester.pumpWidget(MaterialApp(home: Scaffold(body: SignUpPage())));

      // Enter valid data
      await tester.enterText(find.byType(TextFormField).at(0), 'John');
      await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
      await tester.enterText(find.byType(TextFormField).at(2), 'Middle');
      await tester.enterText(find.byType(TextFormField).at(3), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(4), '1234567890');
      await tester.enterText(find.byType(TextFormField).at(5), 'password@Veera');
      await tester.enterText(find.byType(TextFormField).at(6), 'password@Veera');

      // Tap the register button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify that SnackBar is shown
      expect(find.text('Processing Data'), findsOneWidget);
    });
  });
}
