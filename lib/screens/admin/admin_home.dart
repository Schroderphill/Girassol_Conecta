import 'package:flutter/material.dart';
import '/components/layout.dart';
import '/drawers/admin_drawer.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      drawer: const AdminDrawer(),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Administração",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text("Bem-vindo, painel administrador."),
          ],
        ),
      ),
    );
  }
}
