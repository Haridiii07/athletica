import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athletica/data/datasources/supabase_service.dart';
import 'package:athletica/config/app_router.dart';
import 'package:athletica/utils/theme.dart';
import 'package:athletica/widgets/error_widgets.dart';

void main() async {
  print('DEBUG: Starting main()');
  WidgetsFlutterBinding.ensureInitialized();
  print('DEBUG: WidgetsFlutterBinding initialized');

  // Initialize Supabase
  try {
    print('DEBUG: Initializing Supabase...');
    await SupabaseService.initialize().timeout(const Duration(seconds: 5));
    print('DEBUG: Supabase initialized successfully');
  } catch (e) {
    print('DEBUG: Supabase initialization failed: $e');
  }

  // Set up global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('DEBUG: FlutterError: ${details.exception}');
  };

  print('DEBUG: Calling runApp');
  runApp(
    const ProviderScope(
      child: AthleticaApp(),
    ),
  );
}

class AthleticaApp extends ConsumerWidget {
  const AthleticaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'Athletica',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      builder: (context, widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return GlobalErrorWidget(
            errorDetails: errorDetails,
            onRetry: () {
              router.go('/');
            },
          );
        };
        return widget!;
      },
    );
  }
}
