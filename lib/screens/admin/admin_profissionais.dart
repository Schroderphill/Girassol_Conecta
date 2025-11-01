// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/widgets/dropdown_table.dart';
import '/components/modais/profissionais_controller.dart';
import '/services/admin_service.dart';
import '/components/drawers/admin_drawer.dart';

class AdminProfissionaisScreen extends StatefulWidget {
  const AdminProfissionaisScreen({super.key});

  @override
  State<AdminProfissionaisScreen> createState() =>
      _AdminProfissionaisScreenState();
}

class _AdminProfissionaisScreenState extends State<AdminProfissionaisScreen> {
  String _tipoSelecionado = '';
  String _pesquisa = '';
  int _paginaAtual = 0;
  final int _itensPorPagina = 5;

  List<Map<String, dynamic>> _profissionais = [];
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarProfissionais();
  }

  Future<void> _carregarProfissionais() async {
    setState(() => _carregando = true);
    try {
      final lista =
          await AdminService.listarProfissionais(tipo: _tipoSelecionado);
      setState(() => _profissionais = lista);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar profissionais.')),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  String _normalizarTipo(String tipo) {
    switch (tipo) {
      case 'Médico':
        return 'Medico';
      case 'Psicólogo':
        return 'Psicologo';
      case 'Assistente Social':
        return 'AssistenteSocial';
      case 'Admin':
        return 'admin';
      case 'Todos':
        return '';
      default:
        return tipo;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 🔍 Filtra localmente por nome
    final listaFiltrada = _profissionais.where((p) {
      final nome = (p['Nome'] ?? '').toString().toLowerCase();
      return nome.contains(_pesquisa.toLowerCase());
    }).toList();

    /// 📄 Paginação
    final inicio = _paginaAtual * _itensPorPagina;
    final fim = (inicio + _itensPorPagina) > listaFiltrada.length
        ? listaFiltrada.length
        : (inicio + _itensPorPagina);
    final pagina = listaFiltrada.sublist(inicio, fim);

    final totalPaginas =
        (listaFiltrada.length / _itensPorPagina).ceil().clamp(1, double.infinity).toInt();

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('Gestão de Profissionais'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'Adicionar novo profissional',
            onPressed: () => ProfissionaisController.handleAction(
              context,
              action: 'adicionar',
              profissional: const {},
              onRefresh: _carregarProfissionais,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔍 Campo de pesquisa isolado
            TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquisar profissional...',
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

            /// 📦 Container com dropdown + lista + paginação
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    /// 🔽 Dropdown filtro
                    DropdownTable(
                      title: 'Tipo Profissional:',
                      options: const ['Todos', 'Médico', 'Psicólogo', 'Assistente Social', 'Admin'],
                      onSelected: (tipo) {
                        final tipoFormatado = _normalizarTipo(tipo);
                        setState(() {
                          _tipoSelecionado = tipoFormatado;
                          _paginaAtual = 0;
                        });
                        _carregarProfissionais();
                      },
                    ),
                    const SizedBox(height: 16),

                    /// 🧾 Lista paginada
                    Expanded(
                      child: _carregando
                          ? const Center(child: CircularProgressIndicator())
                          : listaFiltrada.isEmpty
                              ? const Center(
                                  child: Text('Nenhum profissional encontrado.'),
                                )
                              : RefreshIndicator(
                                  onRefresh: _carregarProfissionais,
                                  child: ListView.builder(
                                    itemCount: pagina.length,
                                    itemBuilder: (context, index) {
                                      final p = pagina[index];
                                      final nome = p['Nome'] ?? 'Sem nome';
                                      final registro = p['Registro'] ?? '';

                                      return Card(
                                        margin: const EdgeInsets.symmetric(vertical: 6),
                                        elevation: 2,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            child: Text(
                                              nome.isNotEmpty
                                                  ? nome[0].toUpperCase()
                                                  : '?',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          title: Text(nome),
                                          subtitle: Text(
                                              'Registro: $registro\nTipo: $_tipoSelecionado'),
                                          isThreeLine: true,
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.visibility),
                                                tooltip: 'Ver detalhes',
                                                onPressed: () =>
                                                    ProfissionaisController.handleAction(
                                                  context,
                                                  action: 'ver',
                                                  profissional: p,
                                                  onRefresh: _carregarProfissionais,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                tooltip: 'Editar',
                                                onPressed: () =>
                                                    ProfissionaisController.handleAction(
                                                  context,
                                                  action: 'editar',
                                                  profissional: p,
                                                  onRefresh: _carregarProfissionais,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                tooltip: 'Excluir',
                                                onPressed: () =>
                                                    ProfissionaisController.handleAction(
                                                  context,
                                                  action: 'excluir',
                                                  profissional: p,
                                                  onRefresh: _carregarProfissionais,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                    ),

                   
                    /// 📄 Navegação (centralizada e espaçada)
                  if (listaFiltrada.length > _itensPorPagina)
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _paginaAtual > 0
                                ? () => setState(() => _paginaAtual--)
                                : null,
                            icon: const Icon(Icons.chevron_left),
                            tooltip: 'Anterior',
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Página ${_paginaAtual + 1} de $totalPaginas',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: (_paginaAtual + 1) < totalPaginas
                                ? () => setState(() => _paginaAtual++)
                                : null,
                            icon: const Icon(Icons.chevron_right),
                            tooltip: 'Próxima',
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
