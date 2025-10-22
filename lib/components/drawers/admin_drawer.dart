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
          _item(context, Icons.favorite_border, "Acolhimento", '/acolhimento'),
          _item(context, Icons.favorite_border, "Profissional", '/profissional'),
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
