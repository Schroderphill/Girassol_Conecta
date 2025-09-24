import 'package:flutter/material.dart';
import 'drawer_menu.dart';

class Layout extends StatelessWidget {
  final Widget content;
  const Layout({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Girassol Conecta"),
      ),
      drawer: const DrawerMenu(),
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