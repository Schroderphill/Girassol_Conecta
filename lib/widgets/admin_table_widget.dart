
import 'package:flutter/material.dart';

class AdminTableWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;
  final List<String> columns;
  final VoidCallback onAdd;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;

  const AdminTableWidget({
    super.key,
    required this.title,
    required this.data,
    required this.columns,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cabeçalho
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text("Adicionar"),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Tabela
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                ...columns.map((col) => DataColumn(label: Text(col))),
                const DataColumn(label: Text("Ações")),
              ],
              rows: data.map((row) {
                return DataRow(cells: [
                  ...columns.map((col) => DataCell(Text(row[col].toString()))),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => onEdit(row),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onDelete(row),
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
