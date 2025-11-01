import 'package:flutter/material.dart';
//import '/widgets/dropdown_table.dart';
//import '/services/admin_service.dart';
import '/components/drawers/admin_drawer.dart';



class AdminAtividadesScreen extends StatefulWidget {
  const AdminAtividadesScreen({super.key});

  @override
  State<AdminAtividadesScreen> createState() =>
      _AdminAtividadesScreenState();
}

class _AdminAtividadesScreenState extends State<AdminAtividadesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atividades"),
      ),
      drawer: const AdminDrawer(),
      body: const Center(
        child: Text("Conteúdo da tela de atividades do Admin"),
      ),
    );
  }
}