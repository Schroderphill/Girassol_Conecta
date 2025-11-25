//ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/services/auth_service.dart'; //importo pra pegar ID
import '/services/agenda_service.dart';
import '/components/drawers/usuario_drawer.dart';

class UsuarioAgendaScreen extends StatefulWidget {
  const UsuarioAgendaScreen({super.key});

  @override
  State<UsuarioAgendaScreen> createState() => _UsuarioAgendaScreenState();
}

class _UsuarioAgendaScreenState extends State<UsuarioAgendaScreen> {
  // Removido: final AgendasController _controller = AgendasController();
  
  String? _currentUserId; 
  String _pesquisa = '';
  int _paginaAtual = 0;
  final int _itensPorPagina = 5;

  List<Map<String, dynamic>> _agendas = [];
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _iniciarSessaoECarregarAgendas();
  }

  /// 📥 CARREGA ID DA SESSÃO VIA AUTHSERVICE E INICIA O FETCH DA AGENDA
  Future<void> _iniciarSessaoECarregarAgendas() async {
    setState(() => _carregando = true);
    
    // 1. Usa o AuthService para buscar o ID da sessão
    final idSessao = await AuthService.getUserId(); 
    
    if (idSessao != null) {
      setState(() {
        _currentUserId = idSessao;
      });
      // 2. Chama a função de carregamento com o ID da Sessão
      await _carregarAgendasComFiltro(idSessao); 
    } else {
      if(mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro: ID do usuário da sessão não encontrado. Faça login novamente.')),
           );
       }
    }

    if (mounted) {
        setState(() => _carregando = false);
    }
  }
  
  /// 🔄 LOAD com filtro de ID (idSessao)
  Future<void> _carregarAgendasComFiltro(String idSessao) async {
    try {
      final service = AgendaService();
      
      // Passa o 'idSessao' para filtrar no backend
      final lista = await service.fetchAgendaView(
          idSessao: idSessao, 
      ); 

      setState(() {
        _agendas = List<Map<String, dynamic>>.from(lista);
        _paginaAtual = 0;
      });
    } catch (e) {
      if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao carregar agendas: $e')),
          );
      }
    } 
  }

  /// 🔵 FILTRO HOJE
  void _filtrarHoje() {
    if (_currentUserId == null) return;
    
    _carregarAgendasComFiltro(_currentUserId!);

    final hoje = DateTime.now();
    final hojeStr = "${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}";

    setState(() {
      _agendas = _agendas.where((a) => (a['DataAtendimento'] == hojeStr)).toList();
      _paginaAtual = 0;
    });
  }

  /// 🟣 FILTRO SEMANA (Segunda a Sexta)
  void _filtrarSemana() {
    if (_currentUserId == null) return;
    
    _carregarAgendasComFiltro(_currentUserId!);
    
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
      _agendas = _agendas.where((a) => inRange(a['DataAtendimento'] ?? '')).toList();
      _paginaAtual = 0;
    });
  }

  // Removido: _cancelarAgendamento
  // Removido: _remarcarAgendamento

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
      drawer: const UsuarioDrawer(), 
      appBar: AppBar(
        title: const Text('Minha Agenda'), 
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar Agendas',
            onPressed: () {
                if (_currentUserId != null) {
                    _carregarAgendasComFiltro(_currentUserId!);
                }
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
                labelText: 'Pesquisar por nome...', 
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

            // 🔵 BOTÕES HOJE / SEMANA
            Row(
              children: [
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _filtrarHoje,
                    child: const Text("Hoje"),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _filtrarSemana,
                    child: const Text("Semana"),
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
                    const Divider(), 

                    Expanded(
                      child: _carregando
                          ? const Center(child: CircularProgressIndicator())
                          : pagina.isEmpty
                              ? const Center(child: Text('Nenhum agendamento encontrado para o seu ID.'))
                              : ListView.builder(
                                  itemCount: pagina.length,
                                  itemBuilder: (context, index) {
                                    final ag = pagina[index];
                                    final usuarioId = ag['Usuario_idUsuario'].toString();
                                    final usuarioNome = ag['Nome_Usuario'] ?? 'Sem nome';
                                    final profissionalNome = ag['Nome_Profissional'] ?? '—';

                                    final rawData = ag['DataAtendimento'] ?? '';
                                    final rawHora = ag['HoraAtendimento'] ?? '';

                                    final data = rawData.isNotEmpty
                                        ? rawData.split('-').reversed.join('/')
                                        : '';

                                    final hora = rawHora.isNotEmpty
                                        ? rawHora.substring(0, 5)
                                        : '';

                                    final status = ag['Status'] ?? 'Pendente';
                                    
                                    // Determina o título baseado em quem está logado
                                    final titulo = _currentUserId == usuarioId
                                        ? 'Com o Profissional: $profissionalNome' 
                                        : 'Para o Usuário: $usuarioNome'; 

                                    return Card(
                                      child: ListTile(
                                        title: Text(titulo),
                                        subtitle: Text('Tipo: ${ag['Especialidade'] ?? 'Não informado'} | Data: $data às $hora\nStatus: $status'),
                                        // AÇÕES REMOVIDAS: O trailing: Row foi excluído para remover os botões de Editar e Cancelar
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