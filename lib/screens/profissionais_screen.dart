import 'package:flutter/material.dart';
import '../widgets/admin_table_widget.dart';
import 'package:logger/logger.dart';

class ProfissionaisScreen extends StatefulWidget {
  const ProfissionaisScreen({super.key});

  @override
  State<ProfissionaisScreen> createState() => _ProfissionaisScreenState();
}

class _ProfissionaisScreenState extends State<ProfissionaisScreen> {
  // Exemplo de dados (vai vir da API futuramente)
  static final Logger _logger = Logger();

  List<Map<String, dynamic>> profissionais = [
    {"id": 1, "nome": "Dra. Maria", "email": "maria@teste.com"},
    {"id": 2, "nome": "Dr. João", "email": "joao@teste.com"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profissionais")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AdminTableWidget(
          title: "Lista de Profissionais",
          data: profissionais,
          columns: ["id", "nome", "email"],
          onAdd: () {
            // abrir modal de cadastro
            _logger.i("Adicionar novo profissional");
          },
          onEdit: (row) {
            _logger.i("Editar: ${row["id"]}");
          },
          onDelete: (row) {
            setState(() {
              profissionais.removeWhere((p) => p["id"] == row["id"]);
            });
          },
        ),
      ),
    );
  }
}
