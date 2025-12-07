import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athletica/presentation/providers/auth_provider.dart';
import 'package:athletica/presentation/providers/coach_provider.dart';
import 'package:athletica/screens/splash_screen.dart';
import 'package:athletica/screens/landing_screen.dart';
import 'package:athletica/screens/main_screen.dart';
import 'package:athletica/screens/auth/signin_screen.dart';
import 'package:athletica/screens/auth/signup_screen.dart';
import 'package:athletica/screens/auth/forgot_password_screen.dart';
import 'package:athletica/screens/auth/profile_photo_screen.dart';
import 'package:athletica/screens/auth/identity_verification_screen.dart';
import 'package:athletica/screens/auth/otp_screen.dart';
import 'package:athletica/screens/dashboard/home_screen.dart';
import 'package:athletica/screens/dashboard/clients_screen.dart';
import 'package:athletica/screens/dashboard/client_details_screen.dart';
import 'package:athletica/screens/dashboard/client_progress_screen.dart';
import 'package:athletica/screens/dashboard/plans_screen.dart';
import 'package:athletica/screens/dashboard/create_plan_screen.dart';
import 'package:athletica/screens/dashboard/analytics_dashboard_screen.dart';
import 'package:athletica/screens/dashboard/settings_screen.dart';
import 'package:athletica/screens/dashboard/subscription_screen.dart';
import 'package:athletica/screens/dashboard/chat_screen.dart';
import 'package:athletica/screens/dashboard/profile_screen.dart';
import 'package:athletica/data/models/client.dart';

/// Router provider for Riverpod
final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter.createRouter(ref);
});

/// App router configuration using go_router
class AppRouter {
  static GoRouter createRouter(Ref ref) {
    return GoRouter(
      initialLocation: '/landing', // Start directly at landing screen
      debugLogDiagnostics: true,
      redirect: (context, state) {
        // Temporarily disable redirect logic to test navigation
        // Allow all routes for now
        return null;
        
        // Original redirect logic (commented out for debugging)
        // try {
        //   final authState = ref.read(authStateProvider);
        //   final isAuthenticated = authState.value ?? false;
        //
        //   // Handle authentication redirects
        //   if (!isAuthenticated) {
        //     if (state.uri.path.startsWith('/auth/') ||
        //         state.uri.path == '/landing' ||
        //         state.uri.path == '/splash') {
        //       return null; // Allow access to auth screens
        //     }
        //     return '/landing'; // Redirect to landing if not authenticated
        //   }
        //
        //   // Handle authenticated user redirects
        //   if (state.uri.path == '/landing' ||
        //       state.uri.path == '/splash' ||
        //       state.uri.path.startsWith('/auth/')) {
        //     return '/'; // Redirect to home if authenticated
        //   }
        //
        //   return null; // No redirect needed
        // } catch (e) {
        //   // If there's an error reading auth state, allow navigation
        //   return null;
        // }
      },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Landing Screen
      GoRoute(
        path: '/landing',
        name: 'landing',
        builder: (context, state) => const LandingScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const SignInScreen(),
        routes: [
          GoRoute(
            path: 'signin',
            name: 'signin',
            builder: (context, state) => const SignInScreen(),
          ),
          GoRoute(
            path: 'signup',
            name: 'signup',
            builder: (context, state) => const SignUpScreen(),
          ),
          GoRoute(
            path: 'forgot-password',
            name: 'forgot-password',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
          GoRoute(
            path: 'profile-photo',
            name: 'profile-photo',
            builder: (context, state) => const ProfilePhotoScreen(),
          ),
          GoRoute(
            path: 'identity-verification',
            name: 'identity-verification',
            builder: (context, state) => const IdentityVerificationScreen(),
          ),
          GoRoute(
            path: 'otp',
            name: 'otp',
            builder: (context, state) {
              return const OtpScreen();
            },
          ),
          GoRoute(
            path: 'reset-password',
            name: 'reset-password',
            builder: (context, state) {
              // Placeholder - ResetPasswordScreen will be implemented later
              return const ForgotPasswordScreen();
            },
          ),
        ],
      ),

      // Main App Routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MainScreen(),
        routes: [
          // Dashboard Routes
          GoRoute(
            path: 'dashboard',
            name: 'dashboard',
            builder: (context, state) => const HomeScreen(),
          ),

          // Clients Routes
          GoRoute(
            path: 'clients',
            name: 'clients',
            builder: (context, state) => const ClientsScreen(),
            routes: [
              GoRoute(
                path: ':clientId',
                name: 'client-details',
                builder: (context, state) {
                  final clientId = state.pathParameters['clientId']!;
                  // Client data will be fetched from Riverpod provider in the screen
                  return ClientDetailsScreen(clientId: clientId);
                },
                routes: [
                  GoRoute(
                    path: 'progress',
                    name: 'client-progress',
                    builder: (context, state) {
                      final clientId = state.pathParameters['clientId']!;
                      // Client data will be fetched from Riverpod provider in the screen
                      return ClientProgressScreen(clientId: clientId);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Plans Routes
          GoRoute(
            path: 'plans',
            name: 'plans',
            builder: (context, state) => const PlansScreen(),
            routes: [
              GoRoute(
                path: 'create',
                name: 'create-plan',
                builder: (context, state) => const CreatePlanScreen(),
              ),
              GoRoute(
                path: ':planId',
                name: 'plan-details',
                builder: (context, state) {
                  final planId = state.pathParameters['planId']!;
                  // Plan data will be fetched from Riverpod provider in the screen
                  return CreatePlanScreen(planId: planId);
                },
              ),
            ],
          ),

          // Analytics Routes
          GoRoute(
            path: 'analytics',
            name: 'analytics',
            builder: (context, state) => const AnalyticsDashboardScreen(),
          ),

          // Settings Routes
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),

          // Subscription Routes
          GoRoute(
            path: 'subscription',
            name: 'subscription',
            builder: (context, state) => const SubscriptionScreen(),
          ),

          // Chat Routes
          GoRoute(
            path: 'chat',
            name: 'chat',
            builder: (context, state) {
              // Chat screen without specific client - pass null for now
              return ChatScreen(clientId: null);
            },
            routes: [
              GoRoute(
                path: ':clientId',
                name: 'chat-client',
                builder: (context, state) {
                  final clientId = state.pathParameters['clientId']!;
                  // Client data will be fetched from Riverpod provider in the screen
                  return ChatScreen(clientId: clientId);
                },
              ),
            ],
          ),

          // Profile Routes
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),

          // Invite Routes
          GoRoute(
            path: 'invite/:coachId',
            name: 'invite',
            builder: (context, state) {
              // Placeholder - InviteScreen will be implemented later
              return const LandingScreen(); // Placeholder
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri.path}" could not be found.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
    );
  }

  // Static router instance - will be initialized in main.dart with ProviderScope
  static final GoRouter router = GoRouter(
    initialLocation: '/landing', // Temporarily skip splash for testing
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // For now, allow all routes - auth check will be done in screens
      // This will be improved with proper Riverpod integration
      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Landing Screen
      GoRoute(
        path: '/landing',
        name: 'landing',
        builder: (context, state) => const LandingScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const SignInScreen(),
        routes: [
          GoRoute(
            path: 'signin',
            name: 'signin',
            builder: (context, state) => const SignInScreen(),
          ),
          GoRoute(
            path: 'signup',
            name: 'signup',
            builder: (context, state) => const SignUpScreen(),
          ),
          GoRoute(
            path: 'forgot-password',
            name: 'forgot-password',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
          GoRoute(
            path: 'profile-photo',
            name: 'profile-photo',
            builder: (context, state) => const ProfilePhotoScreen(),
          ),
          GoRoute(
            path: 'identity-verification',
            name: 'identity-verification',
            builder: (context, state) => const IdentityVerificationScreen(),
          ),
          GoRoute(
            path: 'otp',
            name: 'otp',
            builder: (context, state) => const OtpScreen(),
          ),
          GoRoute(
            path: 'reset-password',
            name: 'reset-password',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
        ],
      ),

      // Main App Routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MainScreen(),
        routes: [
          // Dashboard Routes
          GoRoute(
            path: 'dashboard',
            name: 'dashboard',
            builder: (context, state) => const HomeScreen(),
          ),

          // Clients Routes
          GoRoute(
            path: 'clients',
            name: 'clients',
            builder: (context, state) => const ClientsScreen(),
            routes: [
              GoRoute(
                path: ':clientId',
                name: 'client-details',
                builder: (context, state) {
                  final clientId = state.pathParameters['clientId']!;
                  return ClientDetailsScreen(clientId: clientId);
                },
                routes: [
                  GoRoute(
                    path: 'progress',
                    name: 'client-progress',
                    builder: (context, state) {
                      final clientId = state.pathParameters['clientId']!;
                      return ClientProgressScreen(clientId: clientId);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Plans Routes
          GoRoute(
            path: 'plans',
            name: 'plans',
            builder: (context, state) => const PlansScreen(),
            routes: [
              GoRoute(
                path: 'create',
                name: 'create-plan',
                builder: (context, state) => const CreatePlanScreen(),
              ),
              GoRoute(
                path: ':planId',
                name: 'plan-details',
                builder: (context, state) {
                  final planId = state.pathParameters['planId']!;
                  return CreatePlanScreen(planId: planId);
                },
              ),
            ],
          ),

          // Analytics Routes
          GoRoute(
            path: 'analytics',
            name: 'analytics',
            builder: (context, state) => const AnalyticsDashboardScreen(),
          ),

          // Settings Routes
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),

          // Subscription Routes
          GoRoute(
            path: 'subscription',
            name: 'subscription',
            builder: (context, state) => const SubscriptionScreen(),
          ),

          // Chat Routes
          GoRoute(
            path: 'chat',
            name: 'chat',
            builder: (context, state) => ChatScreen(clientId: null),
            routes: [
              GoRoute(
                path: ':clientId',
                name: 'chat-client',
                builder: (context, state) {
                  final clientId = state.pathParameters['clientId']!;
                  return ChatScreen(clientId: clientId);
                },
              ),
            ],
          ),

          // Profile Routes
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),

          // Invite Routes
          GoRoute(
            path: 'invite/:coachId',
            name: 'invite',
            builder: (context, state) => const LandingScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri.path}" could not be found.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Router extensions for easier navigation
extension AppRouterExtensions on BuildContext {
  /// Navigate to a route
  void goTo(String location, {Object? extra}) {
    go(location, extra: extra);
  }

  /// Push a route
  void pushTo(String location, {Object? extra}) {
    push(location, extra: extra);
  }

  /// Replace current route
  void replaceTo(String location, {Object? extra}) {
    pushReplacement(location, extra: extra);
  }

  /// Go back
  void goBack() {
    pop();
  }

  /// Navigate to client details
  void goToClient(String clientId) {
    go('/clients/$clientId');
  }

  /// Navigate to client progress
  void goToClientProgress(String clientId) {
    go('/clients/$clientId/progress');
  }

  /// Navigate to plan details
  void goToPlan(String planId) {
    go('/plans/$planId');
  }

  /// Navigate to chat with client
  void goToChat(String clientId) {
    go('/chat/$clientId');
  }

  /// Navigate to invite screen
  void goToInvite(String coachId, {String? token}) {
    final location =
        token != null ? '/invite/$coachId?token=$token' : '/invite/$coachId';
    go(location);
  }
}
