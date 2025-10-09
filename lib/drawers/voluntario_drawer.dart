import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

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
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
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
