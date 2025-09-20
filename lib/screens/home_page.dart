import 'package:flutter/material.dart';
//import '../widgets/sunflower_icon.dart';
import '../theme/app_colors.dart';
import 'package:gc_flutter_app/services/auth_service.dart';
import 'login_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Girassol Conecta"),
        backgroundColor: AppColors.primary,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Cabeçalho do Drawer
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.girassolLight,
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.sunny, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Girassol Conecta",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),

            // Opções principais
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(Icons.favorite_border, "Acolhimento", 0),
                  _buildDrawerItem(Icons.group_outlined, "Voluntários", 1),

                  // Agenda expansível
                  ExpansionTile(
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text("Agenda"),
                    children: [
                      _buildDrawerSubItem("Médico", 2),
                      _buildDrawerSubItem("Psicólogo", 3),
                      _buildDrawerSubItem("Assistente Social", 4),
                    ],
                  ),

                  _buildDrawerItem(Icons.event_outlined, "Eventos", 5),
                ],
              ),
            ),

            // Rodapé do Drawer
            const Divider(),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text("Admin Girassol"),
              subtitle: const Text("admin@girassolconecta.com"),
            ),
            _buildDrawerItem(Icons.person_outline, "Perfil", 6),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sair"),
              onTap: () => _logout(context), //  chama o logout
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          "Página ${_selectedIndex + 1}",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context); // Fecha o Drawer
      },
    );
  }

  Padding _buildDrawerSubItem(String title, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: ListTile(
        title: Text(title),
        selected: _selectedIndex == index,
        onTap: () {
          setState(() => _selectedIndex = index);
          Navigator.pop(context);
        },
      ),
    );
  }
}