import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:athletica/providers/auth_provider.dart';
import 'package:athletica/providers/coach_provider.dart';
import 'package:athletica/screens/auth/signin_screen.dart';
import 'package:athletica/screens/dashboard/home_screen.dart';
import 'package:athletica/utils/theme.dart';
import 'package:athletica/widgets/empty_states.dart';

void main() {
  group('SignInScreen Widget Tests', () {
    testWidgets('should display sign in form elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => CoachProvider()),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const SignInScreen(),
          ),
        ),
      );

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Sign In'), findsOneWidget);
    });
  });

  group('HomeScreen Widget Tests', () {
    testWidgets('should display home screen elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => CoachProvider()),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });

  group('Empty States Widget Tests', () {
    testWidgets('should display empty state widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: EmptyClientsWidget(
              onAddClient: () {},
            ),
          ),
        ),
      );

      expect(find.text('No Clients Yet'), findsOneWidget);
      expect(find.text('Add First Client'), findsOneWidget);
    });
  });

  group('Loading States Widget Tests', () {
    testWidgets('should display loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
