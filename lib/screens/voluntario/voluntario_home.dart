import 'package:flutter/material.dart';
import '/components/layout.dart';
import '/drawers/voluntario_drawer.dart';

class VoluntarioHome extends StatelessWidget {
  const VoluntarioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      drawer: const VoluntarioDrawer(),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Área do Voluntário",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text("Bem-vindo(a)! Aqui você pode acessar seus serviços."),
          ],
        ),
      ),
    );
  }
}
