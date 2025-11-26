// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'package:gc_flutter_app/services/auth_service.dart';
import 'package:gc_flutter_app/screens/login_page.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Text(
              "Girassol Conecta - Admin",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          _item(context, Icons.home, "Home", '/admin'),
          ExpansionTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text("Acolhimento"),
            children: [
              _subItem(context, "Realiza Acolhimento", '/acolhimento'),
              _subItem(context, "Edita Acolhimento", '/editar_acolhimento'),
            ],
          ),

          ExpansionTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text("Agenda"),
            children: [
              _subItem(context, "Agenda Geral", '/admin_agenda'),
              _subItem(context, "Minha Agenda", '/minha_agenda'),             
            ],
          ),
                    
          _item(context, Icons.feed_outlined, "Prontuários", '/admin_prontuario'),

          _item(context, Icons.medical_services, "Profissional", '/profissional'),
          _item(context, Icons.group_outlined, "Usuarios", '/usuarios_gestao'),
                    
           ExpansionTile(
            leading: const Icon(Icons.featured_play_list_outlined),
            title: const Text("Atividades"),
            children: [
              _subItem(context, "Feed", '/feed'),
              _subItem(context, "Atividades", '/atividade_gestao'),              
            ],
          ),

           _item(context, Icons.group_outlined, "Perfil", '/editar_perfil'),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Sair"),
            onTap: () async {
             await AuthService.logout(); // <-- encerra sessão e limpa SharedPreferences
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
           },
          ),
        ],
      ),
    );
  }

  ListTile _item(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => Navigator.pushReplacementNamed(context, route),
    );
  }

  Padding _subItem(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: ListTile(
        title: Text(title),
        onTap: () => Navigator.pushReplacementNamed(context, route),
      ),
    );
  }
}
