import 'package:flutter/material.dart';
import '/screens/admin/admin_acolhimento.dart';
import 'theme/app_theme.dart';
import 'screens/splash_page.dart';
import 'screens/login_page.dart';
//import 'screens/overview_screen.dart'; 
import 'screens/admin/admin_home.dart';
import 'screens/usuario/usuario_home.dart';
import 'screens/admin/admin_profissionais.dart';

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
       


        //|-----------------Usuario----------------|
        '/usuario': (context) => const UsuarioHome(),
         // '/overview': (context) => const OverviewScreen(),

       ////|-----------------Profissional----------------| 
        //'/profissional': (context) => const ProfissionaisScreen(),

        //|-----------------Admin----------------|
        '/admin': (context) => const AdminHome(),
        '/acolhimento': (context) => const AdminAcolhimento(),
        '/profissional': (context) => const AdminProfissionaisScreen(),
        
        // daqui você pode ir adicionando as outras:
        // '/acolhimento': (context) => const AcolhimentoScreen(),
        // '/voluntarios': (context) => const VoluntariosScreen(),
      },
    );
  }
}
