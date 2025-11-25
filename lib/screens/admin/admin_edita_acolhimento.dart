// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/services/acolhimento_service.dart';
import '/components/drawers/admin_drawer.dart';

// Importa o Controller de Acolhimento
import '/components/modais/acolhimento_controller.dart';

class AdmEditAcolhimento extends StatefulWidget {
  const AdmEditAcolhimento({super.key});

  @override
  State<AdmEditAcolhimento> createState() => _AdmEditAcolhimentoState();
}

class _AdmEditAcolhimentoState extends State<AdmEditAcolhimento> {
  // USAR O NOVO CONTROLLER
  final AcolhimentoController _acolhimentoController = AcolhimentoController();

  String _pesquisa = '';
  int _paginaAtual = 0;
  final int _itensPorPagina = 5;

  List<Map<String, dynamic>> _agendas = [];
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarAgendas();
  }

  // NORMAL LOAD (Agora sem filtro de profissional)
  Future<void> _carregarAgendas() async {
    return _carregarAgendasComFiltro('Finalizado');
  }

  // LOAD with filter
  Future<void> _carregarAgendasComFiltro(String? filtro) async {
    setState(() => _carregando = true);

    try {
      final service = AcolhimentoService();
      final lista = await service.fetchAcolhimentoView(
        status: filtro,
      );

      setState(() {
        _agendas = List<Map<String, dynamic>>.from(lista);
        _paginaAtual = 0;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar acolhimentos: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  // FILTRO HOJE
  void _filtrarHoje() {
    final hoje = DateTime.now();
    final hojeStr =
        "${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}";

    _carregarAgendas().then((_) {
      setState(() {
        _agendas =
            _agendas.where((a) => (a['DataAtendimento'] == hojeStr)).toList();
        _paginaAtual = 0;
      });
    });
  }

  // FILTRO SEMANA (Segunda a Sexta)
  void _filtrarSemana() {
    _carregarAgendas().then((_) {
      final hoje = DateTime.now();
      final segunda = hoje.subtract(Duration(days: hoje.weekday - 1));
      final sexta = segunda.add(const Duration(days: 4));

      bool inRange(String dateStr) {
        if (dateStr.isEmpty) return false;
        final parts = dateStr.split("-");
        final d = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        return d.isAfter(segunda.subtract(const Duration(days: 1))) &&
            d.isBefore(sexta.add(const Duration(days: 1)));
      }

      setState(() {
        _agendas = _agendas
            .where((a) => inRange(a['DataAtendimento'] ?? ''))
            .toList();
        _paginaAtual = 0;
      });
    });
  }

  // ACOES DO CONTROLLER

    void _adicionarNucleoFamiliar(Map acolhimento) async {
    await _acolhimentoController.abrirCreateFamiliarModal(
      context,
      acolhimento['idAtendimento'].toString(),
      acolhimento['Nome_Usuario'],
     
    );
    _carregarAgendas();
  }

  void _adicionarDadosEconomicos(Map acolhimento) async {
    await _acolhimentoController.abrirCreateEconomicoModal(
      context,
      acolhimento['idAtendimento'].toString(),
      acolhimento['Nome_Usuario'],
     
    );
    _carregarAgendas();
  }

  @override
  Widget build(BuildContext context) {
    final filtradas = _agendas.where((a) {
      final u = (a['Nome_Usuario'] ?? '').toString().toLowerCase();
      final p = (a['Nome_Profissional'] ?? '').toString().toLowerCase();
      return u.contains(_pesquisa.toLowerCase()) ||
          p.contains(_pesquisa.toLowerCase());
    }).toList();

    final inicio = _paginaAtual * _itensPorPagina;
    final fim = (inicio + _itensPorPagina > filtradas.length)
        ? filtradas.length
        : inicio + _itensPorPagina;
    final pagina = filtradas.sublist(inicio, fim);

    final totalPaginas = (filtradas.length / _itensPorPagina).ceil();

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('Editar Acolhimento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar Acolhimentos',
            onPressed: _carregarAgendas,
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // BUSCA
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Pesquisar por usuário ou profissional...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) {
                  setState(() {
                    _pesquisa = v;
                    _paginaAtual = 0;
                  });
                },
              ),

              const SizedBox(height: 16),

              // FILTROS
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _filtrarHoje,
                        child: const Text("Hoje"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 4,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _filtrarSemana,
                        child: const Text("Semana"),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // LISTA
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
                      // LEGENDA (APENAS BOTÕES AZUIS - ADICIONAR)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.group_add,
                                  size: 18, color: Colors.amber),
                              SizedBox(width: 4),
                              Text('Edita Familiar.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              SizedBox(width: 12),
                              Icon(Icons.attach_money,
                                  size: 18, color: Colors.amber),
                              SizedBox(width: 4),
                              Text('Edita Socioeconômico.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          ),
                          // Removida a linha de legenda dos botões amarelos (Edição)
                        ],
                      ),

                      const Divider(),

                      Expanded(
                        child: _carregando
                            ? const Center(child: CircularProgressIndicator())
                            : pagina.isEmpty
                                ? const Center(
                                    child: Text(
                                        'Nenhum agendamento de acolhimento encontrado.'))
                                : ListView.builder(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          16,
                                    ),
                                    itemCount: pagina.length,
                                    itemBuilder: (context, index) {
                                      final ag = pagina[index];
                                      final usuario =
                                          ag['Nome_Usuario'] ?? 'Sem nome';

                                      final rawData =
                                          ag['DataAtendimento'] ?? '';
                                      final rawHora =
                                          ag['HoraAtendimento'] ?? '';

                                      final data = rawData.isNotEmpty
                                          ? rawData
                                              .split('-')
                                              .reversed
                                              .join('/')
                                          : '';

                                      final hora = rawHora.isNotEmpty
                                          ? rawHora.substring(0, 5)
                                          : '';

                                      final status =
                                          ag['Status'] ?? 'Pendente';

                                      return Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: ListTile(
                                            title: Text('$usuario'),
                                            subtitle: Text(
                                              'Tipo: ${ag['Tipo_solicitacao'] ?? 'Não informado'} \n'
                                              'Data: $data \n'
                                              'Hora: $hora\n'
                                              'Status: $status',
                                            ),
                                            isThreeLine: true,
                                            trailing: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // ADICIONAR (BOTÕES AZUIS)
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      constraints:
                                                          const BoxConstraints(),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      icon: const Icon(
                                                        Icons.group_add,
                                                        color: Colors.amber,
                                                      ),
                                                      onPressed: () =>
                                                          _adicionarNucleoFamiliar(
                                                              ag),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    IconButton(
                                                      constraints:
                                                          const BoxConstraints(),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      icon: const Icon(
                                                        Icons.attach_money,
                                                        color: Colors.amber,
                                                      ),
                                                      onPressed: () =>
                                                          _adicionarDadosEconomicos(
                                                              ag),
                                                    ),
                                                  ],
                                                ),

                                                
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ),

              // PAGINACAO
              if (filtradas.length > _itensPorPagina)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _paginaAtual > 0
                          ? () => setState(() => _paginaAtual--)
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text('Página ${_paginaAtual + 1} de $totalPaginas'),
                    IconButton(
                      onPressed: (_paginaAtual + 1) < totalPaginas
                          ? () => setState(() => _paginaAtual++)
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}