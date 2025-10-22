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
              "Girassol Conecta - Voluntário",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          _item(context, Icons.event_available, "Eventos", '/voluntario_eventos'),
          _item(context, Icons.calendar_today, "Minha Agenda", '/voluntario_agenda'),
          _item(context, Icons.healing, "Solicitar Atendimento", '/voluntario_atendimento'),
          _item(context, Icons.history, "Histórico de Consultas", '/voluntario_historico'),
          _item(context, Icons.history, "Agenda Girassol", '/voluntario_agenda_girassol'),
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
}
