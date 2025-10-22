import 'package:flutter/material.dart';
import '/components/layout.dart';
import '../../components/drawers/admin_drawer.dart';
import '/widgets/table_widget.dart';
import '/services/admin_service.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Map<String, dynamic>> usuarios = [];

  @override
  void initState() {
    super.initState();
    carregarUsuarios();
  }

  Future<void> carregarUsuarios() async {
    final dados = await AdminService.listarUsuarios();
    setState(() {
      usuarios = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      drawer: const AdminDrawer(),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: usuarios.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(248, 240, 233, 233), // Fundo branco
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0x0D), // 0x0D ≈ 5% de opacidade
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TableWidget(
                  title: "Usuários Cadastrados",
                  data: usuarios,
                  columns: [
                    "Nome",
                    "NomeSocial",
                    "CPF",
                    "DataNascimento",
                  ],
                  columnLabels: [
                    "Nome",
                    "Nome Social",
                    "CPF",
                    "Nascimento",
                  ],
                  onView: (row) {
                    debugPrint("Visualizar: ${row['idUsuario']}");
                  },
                  onEdit: (row) {
                    debugPrint("Editar: ${row['idUsuario']}");
                  },
                  onDelete: (row) async {
                    bool ok = await AdminService.excluirUsuario(
                      int.parse(row['idUsuario'].toString()),
                    );
                    if (ok) {
                      carregarUsuarios();
                    }
                  },
                ),
              ),
      ),
    );
  }
}
