import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:athletica/providers/auth_provider.dart';
import 'package:athletica/providers/coach_provider.dart';
import 'package:athletica/screens/splash_screen.dart';
import 'package:athletica/utils/optimized_theme.dart';

// Deferred imports for better code splitting
import 'package:athletica/screens/dashboard/dashboard_screen.dart' deferred as dashboard;
import 'package:athletica/screens/main_screen.dart' deferred as main_screen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Preload critical deferred libraries
  await Future.wait([
    dashboard.loadLibrary(),
    main_screen.loadLibrary(),
  ]);
  
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
        theme: OptimizedAppTheme.darkTheme,
        home: const SplashScreen(),
        // Optimize performance
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
              ),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
