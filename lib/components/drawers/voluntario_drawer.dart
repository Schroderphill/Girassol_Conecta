// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'package:gc_flutter_app/services/auth_service.dart';
import 'package:gc_flutter_app/screens/login_page.dart';

class VoluntarioDrawer extends StatelessWidget {
  const VoluntarioDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Text(
              "Girassol Conecta - Usuário",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          _item(context, Icons.home, "Feed Atividades", '/voluntario'),
          _item(context, Icons.feed_outlined, "Inscrições", "/"),
          
          _item(context, Icons.healing, "Solicitar Atendimento", '/voluntario_atendimento'),
         // _item(context, Icons.calendar_today, "Minha Agenda", '/voluntario_agenda'),

          ExpansionTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text("Agenda"),
            children: [
              _subItem(context, "Agenda Geral", '/voluntario_agenda'),
              _subItem(context, "Minha Agenda", '/voluntario_minha_agenda'),
            ],
          ),

           _item(context, Icons.group_outlined, "Perfil", '/voluntario_perfil'),
          //_item(context, Icons.history, "Histórico de Consultas", '/usuario_historico'),
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
