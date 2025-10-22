import 'package:flutter/material.dart';
import '/components/layout.dart';
import '../../components/drawers/admin_drawer.dart';
//import '/widgets/table_widget.dart'; // ajuste o caminho 

class AdminAcolhimento extends StatelessWidget {
  const AdminAcolhimento({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Exemplo de dados (depois podem vir do banco/API)
    /*final List<Map<String, dynamic>> acolhimentos = [
      {
        "id": 1,
        "usuario": "João Silva",
        "data": "10/09/2025",
        "status": "Pendente",
      },
      {
        "id": 2,
        "usuario": "Maria Souza",
        "data": "12/09/2025",
        "status": "Em análise",
      },
    ];*/

    return Layout(
      drawer: const AdminDrawer(),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
          /*  Expanded(
              //child: TableWidget(
                title: "Solicitações de Acolhimento",
                data: acolhimentos,
                columns: ["id", "usuario", "data", "status"],
                onAdd: () {
                  // Ação ao clicar em "Adicionar"
                  debugPrint("Adicionar acolhimento");
                },
                onEdit: (row) {
                  debugPrint("Editar: ${row['id']}");
                },
                onDelete: (row) {
                  debugPrint("Excluir: ${row['id']}");
                },
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
