import 'package:flutter/material.dart';
import '/widgets/dropdown_table.dart';
import '/services/admin_service.dart';
import '/components/drawers/admin_drawer.dart';



class AdminEventosScreen extends StatefulWidget {
  const AdminEventosScreen({super.key});

  @override
  State<AdminEventosScreen> createState() =>
      _AdminEventosScreenState();
}

class _AdminEventosScreenState extends State<AdminEventosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventos"),
      ),
      drawer: const AdminDrawer(),
      body: const Center(
        child: Text("Conteúdo da tela de eventos"),
      ),
    );
  }
}