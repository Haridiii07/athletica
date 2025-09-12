import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:athletica/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Tests', () {
    testWidgets('Complete sign-in flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to sign-in screen
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Enter credentials
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.pumpAndSettle();

      // Tap sign-in button
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Verify navigation to dashboard
      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('Add client flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Sign in
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Navigate to clients screen
      await tester.tap(find.text('Clients'));
      await tester.pumpAndSettle();

      // Add new client
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Fill client form
      await tester.enterText(find.byType(TextField).first, 'John Doe');
      await tester.enterText(find.byType(TextField).at(1), 'john@example.com');
      await tester.enterText(find.byType(TextField).at(2), '+1234567890');
      await tester.pumpAndSettle();

      // Save client
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify client was added
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('Create plan flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Sign in
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Navigate to plans screen
      await tester.tap(find.text('Plans'));
      await tester.pumpAndSettle();

      // Create new plan
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Fill plan form
      await tester.enterText(find.byType(TextField).first, 'Beginner Plan');
      await tester.enterText(
          find.byType(TextField).at(1), 'A plan for beginners');
      await tester.pumpAndSettle();

      // Save plan
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify plan was created
      expect(find.text('Beginner Plan'), findsOneWidget);
    });

    testWidgets('Settings navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Sign in
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Navigate to settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify settings screen
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('Security'), findsOneWidget);
    });

    testWidgets('Google sign-in flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to sign-in screen
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Tap Google sign-in button
      await tester.tap(find.text('Google'));
      await tester.pumpAndSettle();

      // Verify navigation to dashboard
      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('Facebook sign-in flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to sign-in screen
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Tap Facebook sign-in button
      await tester.tap(find.text('Facebook'));
      await tester.pumpAndSettle();

      // Verify navigation to dashboard
      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('Analytics navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Sign in
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Navigate to analytics
      await tester.tap(find.text('View Analytics'));
      await tester.pumpAndSettle();

      // Verify analytics screen
      expect(find.text('Analytics'), findsOneWidget);
    });

    testWidgets('Logout flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Sign in
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Navigate to settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Tap logout
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      // Confirm logout
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      // Verify navigation back to landing
      expect(find.text('Welcome to Athletica'), findsOneWidget);
    });
  });
}
