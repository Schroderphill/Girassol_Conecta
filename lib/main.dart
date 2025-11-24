import 'package:flutter/material.dart';
//import 'package:gc_flutter_app/screens/first_access.dart';
import '/screens/admin/admin_acolhimento.dart';
import 'theme/app_theme.dart';
import 'screens/splash_page.dart';
import 'screens/login_page.dart';
import 'screens/admin/admin_usuario.dart'; 
import 'screens/admin/admin_home.dart';
//import 'screens/usuario/usuario_home.dart';
import 'screens/admin/admin_profissionais.dart';
import 'screens/admin/admin_perfil.dart';
import 'screens/admin/admin_agenda.dart';
//import 'screens/first_access.dart';
import 'screens/admin/admin_atividades.dart';
import 'screens/usuario/usuario_atividades.dart';
import 'screens/usuario/usuario_perfil.dart';
import 'screens/admin/admin_minha_agenda.dart';
//import 'screens/usuario/usuario_atendimento.dart';

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
        '/usuario': (context) => const UsuarioAtividades(),
        '/usuario_perfil': (context) => const UsuarioPerfil(),
        //'/usuario_atendimento': (context) => const UsuarioaAtendimento(),
         // '/overview': (context) => const OverviewScreen(),

       ////|-----------------Profissional----------------| 
        //'/profissional': (context) => const ProfissionaisScreen(),

        //|-----------------Admin----------------|
        '/admin': (context) => const AdminHome(),
        '/acolhimento': (context) => const AdminAcolhimento(),
        '/profissional': (context) => const AdminProfissionaisScreen(),
        '/usuarios_gestao': (context) => const AdminUsuariosScreen(),
        '/editar_perfil': (context) => const AdminPerfil(),
        '/admin_agenda': (context) => const AdminAgendasScreen(),
        '/minha_agenda': (context) => const MinhaAgendaScreen(),
        '/feed': (context) => const AdminAtividades(),

        // daqui você pode ir adicionando as outras:
        // '/acolhimento': (context) => const AcolhimentoScreen(),
        // '/voluntarios': (context) => const VoluntariosScreen(),
      },
    );
  }
}
