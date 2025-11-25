//ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/services/agenda_service.dart';
import '/components/drawers/admin_drawer.dart';
import '/widgets/dropdown_table.dart';
import '/components/modais/agendas_controller.dart';

class AdminAgendasScreen extends StatefulWidget {
  const AdminAgendasScreen({super.key});

  @override
  State<AdminAgendasScreen> createState() => _AdminAgendasScreenState();
}

class _AdminAgendasScreenState extends State<AdminAgendasScreen> {
  final AgendasController _controller = AgendasController();

  String _tipoProfissionalSelecionado = 'Todos';
  String _pesquisa = '';
  int _paginaAtual = 0;
  final int _itensPorPagina = 5;

  List<Map<String, dynamic>> _agendas = [];
  bool _carregando = false;
  // Armazena a lista completa de agendas carregada da API para poder filtrar
  List<Map<String, dynamic>> _agendasCompletas = []; // Alterado

  @override
  void initState() {
    super.initState();
    _carregarAgendas();
  }

  // NORMALIZA para o backend
  String _normalizarTipo(String tipo) {
    switch (tipo) {
      case 'Médico':
        return 'Medico';
      case 'Psicólogo':
        return 'Psicologo';
      case 'Assistente Social':
        return 'AssistenteSocial';
      default:
        return '';
    }
  }

  // NORMAL LOAD
  Future<void> _carregarAgendas() async {
    return _carregarAgendasComFiltro(
      _normalizarTipo(_tipoProfissionalSelecionado),
    );
  }

  // LOAD with filter
  Future<void> _carregarAgendasComFiltro(String filtro) async {
    setState(() => _carregando = true);

    try {
      final service = AgendaService();
      final lista = await service.fetchAgendaView(
        tipoProfissional: filtro.isEmpty ? null : filtro,
      );

      setState(() {
        // Armazena a lista completa e a lista filtrada/paginada (inicialmente iguais)
        _agendasCompletas = List<Map<String, dynamic>>.from(lista); // Alterado
        _agendas = List<Map<String, dynamic>>.from(lista); // Alterado
        _paginaAtual = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar agendas: $e')),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  // 🔵 FILTRO HOJE
  void _filtrarHoje() {
    final hoje = DateTime.now();
    final hojeStr = "${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}";

    setState(() {
     _agendas = _agendasCompletas.where((a) => (a['DataAtendimento'] == hojeStr)).toList(); // Alterado
      _paginaAtual = 0;
    });
  }

  // 🟣 FILTRO SEMANA (Segunda a Sexta)
  void _filtrarSemana() {
    final hoje = DateTime.now();
    final segunda = hoje.subtract(Duration(days: hoje.weekday - 1));
    final sexta = segunda.add(const Duration(days: 4));

    bool inRange(String dateStr) {
      if (dateStr.isEmpty) return false;
      final parts = dateStr.split("-");
      final d = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      return d.isAfter(segunda.subtract(const Duration(days: 1))) && d.isBefore(sexta.add(const Duration(days: 1)));
    }

    setState(() {
      _agendas = _agendasCompletas.where((a) => inRange(a['DataAtendimento'] ?? '')).toList(); // Alterado
      _paginaAtual = 0;
    });
  }

  // 🟡 NOVO: FILTRO SOLICITAÇÕES (Status = Solicitado)
  void _filtrarSolicitacoes() { // NOVO MÉTODO
    setState(() {
      // Filtra a partir da lista completa (limpa filtros anteriores)
      _agendas = _agendasCompletas.where((a) => (a['Status'] == 'Solicitado')).toList();
      _paginaAtual = 0;
    });
  }

  // 🔴 CANCELAR AGENDAMENTO
  Future<void> _cancelarAgendamento(String idAtendimento) async {
    await _controller.abrirCancelModal(context, idAtendimento);
    await _carregarAgendas();
  }

  // ✏️ REMARCAR (abre modal)
  void _remarcarAgendamento(Map agenda) {
    _controller.abrirEditModal(context, agenda).then((_) => _carregarAgendas());
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
        title: const Text('Agendamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Novo Agendamento',
            onPressed: () {
              _controller.abrirAddModal(context).then((_) => _carregarAgendas());
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 PESQUISAR
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

            // 🔵 BOTÕES HOJE / SEMANA / SOLICITAÇÕES
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _filtrarHoje,
                        child: const Text("Hoje"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1, // Alterado: Reduzido o flex para abrir espaço para o novo botão
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _filtrarSemana,
                        child: const Text("Semana"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // NOVO: Espaçamento para o botão Solicitacões
                Flexible( // NOVO: Botão Solicitacões
                  flex: 2, 
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _filtrarSolicitacoes, // Chamada para o novo filtro
                        //icon: const Icon(Icons.pending_actions, size: 18),
                        label: const Text("Solicitações"),
                      ),
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
                    // FILTRO PROFISSIONAL
                    DropdownTable(
                      title: 'Tipo Profissional:',
                      options: const ['Todos', 'Médico', 'Psicólogo', 'Assistente Social'],
                      onSelected: (tipo) {
                        final normalizado = _normalizarTipo(tipo);
                        setState(() => _tipoProfissionalSelecionado = normalizado);
                        _carregarAgendasComFiltro(normalizado);
                      },
                    ),

                    const Divider(),

                    Expanded(
                      child: _carregando
                          ? const Center(child: CircularProgressIndicator())
                          : pagina.isEmpty
                              ? const Center(child: Text('Nenhum agendamento encontrado.'))
                              : ListView.builder(
                                  itemCount: pagina.length,
                                  itemBuilder: (context, index) {
                                    final ag = pagina[index];
                                    final usuario = ag['Nome_Usuario'] ?? 'Sem nome';
                                    final profissional = ag['Nome_Profissional'] ?? '—';

                                    final rawData = ag['DataAtendimento'] ?? '';
                                    final rawHora = ag['HoraAtendimento'] ?? '';

                                    final data = rawData.isNotEmpty
                                        ? rawData.split('-').reversed.join('/')
                                        : '';

                                    final hora = rawHora.isNotEmpty
                                        ? rawHora.substring(0, 5)
                                        : '';

                                    final status = ag['Status'] ?? 'Pendente';

                                    return Card(
                                      child: ListTile(
                                        title: Text('$usuario com $profissional'),
                                        subtitle: Text('Data: $data às $hora\nStatus: $status'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () => _remarcarAgendamento(ag),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.cancel),
                                              onPressed: () => _cancelarAgendamento(ag['idAtendimento'].toString()),
                                            ),
                                          ],
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

            // PAGINAÇÃO
            if (filtradas.length > _itensPorPagina)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed:
                        _paginaAtual > 0 ? () => setState(() => _paginaAtual--) : null,
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
    );
  }
}