import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:athletica/providers/auth_provider.dart';
import 'package:athletica/providers/coach_provider.dart';
import 'package:athletica/screens/splash_screen.dart';
import 'package:athletica/utils/theme.dart';
import 'package:athletica/services/performance_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize performance optimizations
  await PerformanceService.initialize();
  
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
        home: const SplashScreen(),
      ),
    );
  }
}
