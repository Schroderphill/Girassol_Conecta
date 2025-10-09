import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class UsuarioDrawer extends StatelessWidget {
  const UsuarioDrawer({super.key});

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
          _item(context, Icons.event_available, "Eventos", '/usuario_eventos'),
          _item(context, Icons.calendar_today, "Minha Agenda", '/usuario_agenda'),
          _item(context, Icons.healing, "Solicitar Atendimento", '/usuario_atendimento'),
          _item(context, Icons.history, "Histórico de Consultas", '/usuario_historico'),
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
