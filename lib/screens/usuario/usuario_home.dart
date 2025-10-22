import 'package:flutter/material.dart';
import '/components/layout.dart';
import '../../components/drawers/usuario_drawer.dart';

class UsuarioHome extends StatelessWidget {
  const UsuarioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      drawer: const UsuarioDrawer(),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Área do Usuário",
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
