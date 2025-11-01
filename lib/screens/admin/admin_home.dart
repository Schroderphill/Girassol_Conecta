// ignore_for_file: use_build_context_synchronously

  import 'package:flutter/material.dart';
  import '/components/layout.dart';
  import '/components/drawers/admin_drawer.dart';
  import '/services/admin_service.dart';

  class AdminHome extends StatefulWidget {
    const AdminHome({super.key});

    @override
    State<AdminHome> createState() => _AdminHomeState();
  }

  class _AdminHomeState extends State<AdminHome> {
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
      final dados = await AdminService.listarAtividades(); // ✅ nome correto
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

      // desestruturar o record retornado (bool ok, String msg)
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
        // atualizar lista se necessário
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
        final desc = (a['Descricao'] ?? '').toString().toLowerCase();
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
        drawer: const AdminDrawer(),
        content: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 🔍 Campo de pesquisa isolado
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
                  child: _carregando
                      ? const Center(child: CircularProgressIndicator())
                      : listaFiltrada.isEmpty
                          ? const Center(
                              child: Text('Nenhuma atividade encontrada.'),
                            )
                          : Column(
                              children: [
                                /// 🧾 Lista de atividades (feed)
                                Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: _carregarAtividades,
                                    child: ListView.builder(
                                      itemCount: pagina.length,
                                      itemBuilder: (context, index) {
                                        final a = pagina[index];
                                        final descricao =
                                            a['DescAtividade'] ?? 'Sem descrição';
                                        final hora = a['Hora'] ?? '--:--';
                                        final local = a['LocalAtividade'] ?? 'Não informado';
                                        final imagemBytes = a['Imagem'];
                                        final imagemWidget =
                                            (imagemBytes != null && imagemBytes.isNotEmpty)
                                                ? Image.memory(
                                                    imagemBytes,
                                                    width: double.infinity,
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    height: 200,
                                                    color: Colors.grey.shade200,
                                                    child: const Icon(
                                                      Icons.image_not_supported,
                                                      size: 64,
                                                      color: Colors.grey,
                                                    ),
                                                  );

                                        return Card(
                                          margin:
                                              const EdgeInsets.symmetric(vertical: 8),
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                        top: Radius.circular(12)),
                                                child: imagemWidget,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: ElevatedButton.icon(
                                                        onPressed: () =>
                                                            _participarAtividade(
                                                                a['idAtividade']),
                                                        icon: const Icon(Icons
                                                            .check_circle_outline),
                                                        label: const Text(
                                                            'Participar'),
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
                                  ),
                                ),

                                /// 📄 Navegação da página
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
                                              fontSize: 16),
                                        ),
                                        const SizedBox(width: 16),
                                        ElevatedButton.icon(
                                          onPressed:
                                              (_paginaAtual + 1) < totalPaginas
                                                  ? () => setState(
                                                      () => _paginaAtual++)
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
              ),
            ],
          ),
        ),
      );
    }
  }
