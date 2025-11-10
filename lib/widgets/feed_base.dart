import 'package:flutter/material.dart';

/// Widget genérico e reutilizável para exibição de atividades/eventos.
/// Recebe a lista de dados, controle de carregamento e função de ação principal (ex: participar).
class FeedBase extends StatelessWidget {
  final List<Map<String, dynamic>> atividades;
  final bool carregando;
  final Future<void> Function()? onRefresh;
  final void Function(int idAtividade)? onParticipar;

  const FeedBase({
    super.key,
    required this.atividades,
    this.carregando = false,
    this.onRefresh,
    this.onParticipar,
  });

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (atividades.isEmpty) {
      return const Center(
        child: Text('Nenhuma atividade encontrada.'),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView.builder(
        itemCount: atividades.length,
        itemBuilder: (context, index) {
          final a = atividades[index];
          final descricao = a['DescAtividade'] ?? 'Sem descrição';
          final hora = a['Hora'] ?? '--:--';
          final local = a['LocalAtividade'] ?? 'Não informado';
          final imagemCaminho = a['DivulgaAtividade']?.toString();
          final imagemWidget = (imagemCaminho != null && imagemCaminho.isNotEmpty)
              ? Image.network(
                  // 🔹 Exibe imagem da pasta da API
                  'http://192.168.0.10/gc_api/$imagemCaminho',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, size: 64, color: Colors.grey),
                  ),
                )
              : Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                );

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: imagemWidget,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        descricao,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('⏰ Hora: $hora'),
                      Text('📍 Local: $local'),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () => onParticipar?.call(a['idAtividade']),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Participar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
