import 'package:flutter/material.dart';

class TableWidget extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> data;
  final List<String> columns;       // nomes reais do banco
  final List<String> columnLabels;  // nomes exibidos na tabela
  final Function(Map<String, dynamic>) onView;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;

  const TableWidget({
    super.key,
    required this.title,
    required this.data,
    required this.columns,
    required this.columnLabels,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  static const int rowsPerPage = 5;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    int startIndex = currentPage * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    List<Map<String, dynamic>> pageData =
        widget.data.sublist(startIndex, endIndex > widget.data.length ? widget.data.length : endIndex);

    int totalPages = (widget.data.length / rowsPerPage).ceil();

    return Column(
      children: [
        // Cabeçalho
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
        const SizedBox(height: 16),

        // Tabela
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                ...widget.columnLabels.map((label) => DataColumn(label: Text(label))),
                const DataColumn(label: Text("Ações")),
              ],
              rows: pageData.map((row) {
                return DataRow(cells: [
                  ...widget.columns.map(
                    (col) => DataCell(Text(row[col]?.toString() ?? "")),
                  ),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye, color: Colors.teal),
                          onPressed: () => widget.onView(row),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => widget.onEdit(row),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => widget.onDelete(row),
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),

        // Paginação
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Página ${currentPage + 1} de $totalPages"),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: currentPage > 0
                    ? () => setState(() => currentPage--)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: currentPage < totalPages - 1
                    ? () => setState(() => currentPage++)
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
