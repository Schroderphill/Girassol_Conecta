import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

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
          _item(context, Icons.dashboard, "Visão Geral", '/overview'),
          _item(context, Icons.favorite_border, "Acolhimento", '/acolhimento'),
          ExpansionTile(
            leading: const Icon(Icons.medical_services),
            title: const Text("Profissionais"),
            children: [
              _subItem(context, "Médicos", '/profissionais_medicos'),
              _subItem(context, "Psicólogos", '/profissionais_psicologos'),
              _subItem(context, "Assistente Social", '/profissionais_assistentes'),
            ],
          ),
          _item(context, Icons.group_outlined, "Voluntários", '/voluntarios'),
          ExpansionTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text("Agenda"),
            children: [
              _subItem(context, "Médico", '/agenda_medico'),
              _subItem(context, "Assistente Social", '/agenda_assistente'),
              _subItem(context, "Psicólogo", '/agenda_psicologo'),
            ],
          ),
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
