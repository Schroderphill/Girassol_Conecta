import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_page.dart';
import 'screens/login_page.dart';
import 'screens/overview_screen.dart';

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
      theme:  AppTheme.theme, //aplicando o tema personalizado
      // Rota inicial: SplashPage (decide se vai para Login ou Home)
      home: const SplashPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/overview': (context) => const OverviewScreen(),
        // daqui você pode ir adicionando as outras:
        // '/acolhimento': (context) => const AcolhimentoScreen(),
        // '/voluntarios': (context) => const VoluntariosScreen(),
      },
    );
  }
}
