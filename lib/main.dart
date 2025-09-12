import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:athletica/providers/auth_provider.dart';
import 'package:athletica/providers/coach_provider.dart';
import 'package:athletica/utils/theme.dart';
import 'package:athletica/widgets/error_widgets.dart';
import 'package:athletica/screens/landing_screen.dart';
import 'package:athletica/screens/main_screen.dart';
import 'package:athletica/features/auth/screens/signin_screen.dart';
import 'package:athletica/screens/auth/signup_screen.dart';
import 'package:athletica/screens/auth/forgot_password_screen.dart';
import 'package:athletica/screens/auth/profile_photo_screen.dart';
import 'package:athletica/screens/auth/identity_verification_screen.dart';
import 'package:athletica/screens/auth/otp_screen.dart';
import 'package:athletica/features/dashboard/home/home_screen.dart';
import 'package:athletica/features/dashboard/clients/clients_screen.dart';
import 'package:athletica/screens/dashboard/plans_screen.dart';
import 'package:athletica/screens/dashboard/create_plan_screen.dart';
import 'package:athletica/screens/dashboard/analytics_dashboard_screen.dart';
import 'package:athletica/screens/dashboard/settings_screen.dart';
import 'package:athletica/screens/dashboard/subscription_screen.dart';
import 'package:athletica/screens/dashboard/profile_screen.dart';
import 'package:athletica/screens/dashboard/about_us_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  runApp(const AthleticaApp());
}

class AthleticaApp extends StatelessWidget {
  const AthleticaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CoachProvider()),
      ],
      child: MaterialApp(
        title: 'Athletica',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const LandingScreen(), // Start directly at landing screen
        routes: {
          '/landing': (context) => const LandingScreen(),
          '/signin': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/profile-photo': (context) => const ProfilePhotoScreen(),
          '/identity-verification': (context) =>
              const IdentityVerificationScreen(),
          '/otp': (context) => const OtpScreen(),
          '/main': (context) => const MainScreen(),
          '/home': (context) => const HomeScreen(),
          '/clients': (context) => const ClientsScreen(),
          '/plans': (context) => const PlansScreen(),
          '/create-plan': (context) => const CreatePlanScreen(),
          '/analytics': (context) => const AnalyticsDashboardScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/subscription': (context) => const SubscriptionScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/about': (context) => const AboutUsScreen(),
        },
        builder: (context, widget) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return GlobalErrorWidget(
              errorDetails: errorDetails,
              onRetry: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
            );
          };
          return widget!;
        },
      ),
    );
  }
}
