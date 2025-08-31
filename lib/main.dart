import 'package:flutter/material.dart';
import 'package:gc_flutter_app/theme/app_colors.dart';
import 'screens/splash_page.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const GirassolConectaApp());
}

class GirassolConectaApp extends StatelessWidget {
  const GirassolConectaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Girassol Conecta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Definições globais de tema
        primaryColor: AppColors.girassolDark,
        scaffoldBackgroundColor: AppColors.girassolBg,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.girassolDark,
          secondary: AppColors.girassolLight,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
      ),
      // Rota inicial: SplashPage (decide se vai para Login ou Home)
      home: const SplashPage(),
      routes: {
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
      },
    );
  }
}
