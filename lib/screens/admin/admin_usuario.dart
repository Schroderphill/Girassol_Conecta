// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/widgets/dropdown_table.dart';
import '/services/admin_service.dart';
import '/components/modais/usuarios_controller.dart';
import '/components/drawers/admin_drawer.dart';

class AdminUsuariosScreen extends StatefulWidget {
  const AdminUsuariosScreen({super.key});

  @override
  State<AdminUsuariosScreen> createState() => _AdminUsuariosScreenState();
}

class _AdminUsuariosScreenState extends State<AdminUsuariosScreen> {
  String _tipoSelecionado = '';
  String _pesquisa = '';
  int _paginaAtual = 0;
  final int _itensPorPagina = 5;

  List<Map<String, dynamic>> _usuarios = [];
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async {
    setState(() => _carregando = true);
    try {
      final lista = await AdminService.listarUsuarios();
      setState(() => _usuarios = lista);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar usuários.')),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  /// 🔽 Função que aplica o filtro (Usuário / Voluntário)
  List<Map<String, dynamic>> _aplicarFiltroTipo() {
    if (_tipoSelecionado.isEmpty || _tipoSelecionado == 'Todos') {
      return _usuarios;
    }

    return _usuarios.where((u) {
      final useridVoluntario = u['UseridVoluntario'];
      final ehVoluntario = useridVoluntario != null && useridVoluntario.toString().isNotEmpty;
      return _tipoSelecionado == 'Voluntário' ? ehVoluntario : !ehVoluntario;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    /// 🧭 Aplica filtro de tipo
    final filtrados = _aplicarFiltroTipo();

    /// 🔍 Filtra localmente por nome
    final listaFiltrada = filtrados.where((u) {
      final nome = (u['NomeUsuario'] ?? '').toString().toLowerCase();
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
        title: const Text('Gestão de Usuários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'Adicionar novo usuário',
            onPressed: () => UsuariosController.handleAction(
              context,
              action: 'adicionar',
              usuario: const {},
              onRefresh: _carregarUsuarios,
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
                labelText: 'Pesquisar usuário...',
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
                    /// 🔽 Dropdown filtro (Usuário / Voluntário)
                    DropdownTable(
                      title: 'Tipo:',
                      options: const ['Todos', 'Usuário', 'Voluntário'],
                      onSelected: (tipo) {
                        setState(() {
                          _tipoSelecionado = tipo;
                          _paginaAtual = 0;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    /// 🧾 Lista paginada
                    Expanded(
                      child: _carregando
                          ? const Center(child: CircularProgressIndicator())
                          : listaFiltrada.isEmpty
                              ? const Center(
                                  child: Text('Nenhum usuário encontrado.'),
                                )
                              : RefreshIndicator(
                                  onRefresh: _carregarUsuarios,
                                  child: ListView.builder(
                                    itemCount: pagina.length,
                                    itemBuilder: (context, index) {
                                      final u = pagina[index];
                                      final nome = u['NomeSocial'] ?? 'Sem nome';
                                      final cpf = u['CPF'] ?? '—';
                                      final useridVoluntario = u['UseridVoluntario'];
                                      final tipo = (useridVoluntario != null &&
                                              useridVoluntario.toString().isNotEmpty)
                                          ? 'Voluntário'
                                          : 'Usuário';

                                      return Card(
                                        margin: const EdgeInsets.symmetric(vertical: 6),
                                        elevation: 2,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                Theme.of(context).colorScheme.primary,
                                            child: Text(
                                              nome.isNotEmpty
                                                  ? nome[0].toUpperCase()
                                                  : '?',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          title: Text(nome),
                                          subtitle: Text('CPF: $cpf\nTipo: $tipo'),
                                          isThreeLine: true,
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.visibility),
                                                tooltip: 'Ver detalhes',
                                                onPressed: () =>
                                                    UsuariosController.handleAction(
                                                  context,
                                                  action: 'ver',
                                                  usuario: u,
                                                  onRefresh: _carregarUsuarios,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                tooltip: 'Editar',
                                                onPressed: () =>
                                                    UsuariosController.handleAction(
                                                  context,
                                                  action: 'editar',
                                                  usuario: u,
                                                  onRefresh: _carregarUsuarios,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                tooltip: 'Excluir',
                                                onPressed: () =>
                                                    UsuariosController.handleAction(
                                                  context,
                                                  action: 'excluir',
                                                  usuario: u,
                                                  onRefresh: _carregarUsuarios,
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
