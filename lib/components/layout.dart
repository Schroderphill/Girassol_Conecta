import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final Widget content;
  final Widget? drawer; // Agora opcional

  const Layout({
    super.key,
    required this.content,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Girassol Conecta"),
        automaticallyImplyLeading: true,
      ),
      drawer: drawer, // Nada de DrawerMenu fixo aqui
      body: content,
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const Text(
          "© 2025 Girassol Conecta",
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ),
    );
  }
}
