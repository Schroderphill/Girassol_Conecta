import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/login_page.dart';
import '../theme/app_colors.dart';

class DrawerMenu extends StatelessWidget {
  final String? currentRoute; // para destacar item selecionado

  const DrawerMenu({super.key, this.currentRoute});

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.surface,
                  radius: 24,
                  child: Icon(
                    Icons.wb_sunny,
                    color: AppColors.primaryDark,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Girassol Conecta",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),

          // Itens principais
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(context, Icons.dashboard, "Visão Geral", '/overview'),
                _buildDrawerItem(context, Icons.favorite_border, "Acolhimento", '/acolhimento'),
                _buildDrawerItem(context, Icons.group_outlined, "Voluntários", '/voluntarios'),

                ExpansionTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text("Agenda"),
                  children: [
                    _buildDrawerSubItem(context, "Médico", '/agenda_medico'),
                    _buildDrawerSubItem(context, "Psicólogo", '/agenda_psicologo'),
                    _buildDrawerSubItem(context, "Assistente Social", '/agenda_assistente'),
                  ],
                ),

                _buildDrawerItem(context, Icons.event_outlined, "Eventos", '/eventos'),
              ],
            ),
          ),

          const Divider(),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(Icons.person, color: AppColors.primaryDark),
            ),
            title: Text(
              "Admin Girassol",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              "admin@girassolconecta.com",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          _buildDrawerItem(context, Icons.person_outline, "Perfil", '/perfil'),

          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: Text(
              "Sair",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.error,
                  ),
            ),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryDark),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      selected: currentRoute == route,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.pop(context); // fecha o Drawer se já está na rota
        }
      },
    );
  }

  Padding _buildDrawerSubItem(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: ListTile(
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        selected: currentRoute == route,
        selectedTileColor: AppColors.primary.withOpacity(0.1),
        onTap: () {
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushReplacementNamed(context, route);
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
