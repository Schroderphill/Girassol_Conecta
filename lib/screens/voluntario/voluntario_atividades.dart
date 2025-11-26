// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/components/layout.dart';
import '/components/drawers/voluntario_drawer.dart';
import '/widgets/feed_base.dart'; 
import '/services/admin_service.dart';

class VoluntarioAtividades extends StatefulWidget {
  const VoluntarioAtividades({super.key});

  @override
  State<VoluntarioAtividades> createState() => _VoluntarioAtividadesState();
}

class _VoluntarioAtividadesState extends State<VoluntarioAtividades> {
  List<Map<String, dynamic>> _atividades = [];
  String _pesquisa = '';
  int _paginaAtual = 0;
  final int _itensPorPagina = 5;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarAtividades();
  }

  /// 🔹 Busca as atividades no backend
  Future<void> _carregarAtividades() async {
    setState(() => _carregando = true);
    try {
      final dados = await AdminService.listarAtividades();
      if (dados.isNotEmpty) {
        setState(() => _atividades = List<Map<String, dynamic>>.from(dados));
      } else {
        setState(() => _atividades = []);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nenhuma atividade encontrada.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar atividades: $e')),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  /// 🧩 Função para registrar participação
  Future<void> _participarAtividade(int idAtividade) async {
    try {
      const int idUsuario = 1; // temporário para teste
      final (ok, msg) = await AdminService.participarAtividade(
        idUsuario: idUsuario,
        idAtividade: idAtividade,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: ok ? Colors.green : Colors.red,
        ),
      );

      if (ok) {
        await _carregarAtividades();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 🔍 Filtro local por nome/descrição
    final listaFiltrada = _atividades.where((a) {
      final desc = (a['DescAtividade'] ?? '').toString().toLowerCase();
      return desc.contains(_pesquisa.toLowerCase());
    }).toList();

    /// 📄 Paginação
    final inicio = _paginaAtual * _itensPorPagina;
    final fim = (inicio + _itensPorPagina) > listaFiltrada.length
        ? listaFiltrada.length
        : (inicio + _itensPorPagina);
    final pagina = listaFiltrada.sublist(inicio, fim);
    final totalPaginas =
        (listaFiltrada.length / _itensPorPagina).ceil().clamp(1, double.infinity).toInt();

    return Layout(
      drawer: const VoluntarioDrawer(),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔍 Campo de pesquisa
            TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquisar atividade...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (valor) {
                setState(() {
                  _pesquisa = valor;
                  _paginaAtual = 0;
                });
              },
            ),
            const SizedBox(height: 20),

            /// 📦 Container principal com feed e paginação
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: FeedBase(
                  atividades: pagina,
                  carregando: _carregando,
                  onRefresh: _carregarAtividades,
                  onParticipar: _participarAtividade,
                ),
              ),
            ),

            /// 📄 Navegação entre páginas
            if (listaFiltrada.length > _itensPorPagina)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _paginaAtual > 0
                          ? () => setState(() => _paginaAtual--)
                          : null,
                      icon: const Icon(Icons.chevron_left),
                      label: const Text('Anterior'),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Página ${_paginaAtual + 1} de $totalPaginas',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: (_paginaAtual + 1) < totalPaginas
                          ? () => setState(() => _paginaAtual++)
                          : null,
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('Próxima'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
