import 'package:flutter/material.dart';

class PerfilWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> fields;
  final VoidCallback? onSave;

  const PerfilWidget({
    super.key,
    required this.title,
    required this.fields,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho da seção
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),

            // Campos dinâmicos
            ...fields.map((field) {
              final controller = field['controller'] as TextEditingController;
              final label = field['label'] as String;
              final type = field['type'] ?? TextInputType.text;
              final readOnly = field['readOnly'] ?? false;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: TextField(
                  controller: controller,
                  readOnly: readOnly,
                  keyboardType: type,
                  decoration: InputDecoration(
                    labelText: label,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),

            // Botão de salvar, opcional
            if (onSave != null)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save_rounded, size: 20),
                  label: const Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B7ED0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
