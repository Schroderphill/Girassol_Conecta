// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '/services/auth_service.dart';
import '/services/admin_service.dart';
import '/services/agenda_service.dart';

// Layout e Drawers do usuário
import '/components/layout.dart';
import '../../components/drawers/usuario_drawer.dart';


// =======================================================
//  MODELO PROFISSIONAL (ajuste conforme seu backend real)
// =======================================================

class Profissional {
  final String idProfissional;
  final String nome;
  final String profissionalTipo;

  const Profissional({
    required this.idProfissional,
    required this.nome,
    required this.profissionalTipo,
  });

  factory Profissional.fromJson(Map<String, dynamic> json) {
    return Profissional(
      idProfissional: json['idProfissional'].toString(),
      nome: json['Nome'] ?? json['nome'] ?? '',
      profissionalTipo: json['ProfissionalTipo'] ?? '',
    );
  }
}


// =======================================================
//  TELA DE SOLICITAÇÃO DE ATENDIMENTO
// =======================================================

class UsuarioAtendimento extends StatefulWidget {
  const UsuarioAtendimento({super.key});

  @override
  State<UsuarioAtendimento> createState() => _UsuarioAtendimentoState();
}

class _UsuarioAtendimentoState extends State<UsuarioAtendimento> {
  final Logger _logger = Logger();
  List<Profissional> _profissionais = [];
  bool _isLoading = true;
  String? _idUsuario;

  final List<String> _tiposAtendimento = ['Acolhimento', 'Consulta'];

  Profissional? _profissionalSelecionado;
  String? _tipoAtendimentoSelecionado;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  /// Carregar dados reais da API
  Future<void> _carregarDados() async {
    try {
      // 1. Buscar ID da sessão real
      final userId = await AuthService.getUserId();

      // 2. Buscar lista de profissionais reais da API
      final resposta = await AdminService.listarProfissionais();

      setState(() {
        _idUsuario = userId.toString();
        _profissionais = resposta.map<Profissional>((p) {
          return Profissional.fromJson(p);
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      _logger.e('Erro ao carregar dados');
      
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao carregar dados: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Enviar solicitação real para o backend
  void _solicitarAtendimento() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final Map<String, dynamic> solicitacao = {
      'Profissional_idProfissional': _profissionalSelecionado!.idProfissional,
      'Tipo_solicitacao': _tipoAtendimentoSelecionado,
      'Usuario_idUsuario': _idUsuario,
      //'dataSolicitacao': DateTime.now().toIso8601String(),
    };

    final overlay = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black45,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
    Overlay.of(context).insert(overlay);

    try {
      // Usa seu AgendaService REAL
      await AgendaService().addAgenda(solicitacao);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Solicitação de $_tipoAtendimentoSelecionado enviada!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _profissionalSelecionado = null;
        _tipoAtendimentoSelecionado = null;
      });
    } catch (e) {
      _logger.e('Erro ao enviar solicitação');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar solicitação: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      overlay.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Layout(
        drawer: UsuarioDrawer(),
        content: Center(child: CircularProgressIndicator()),
      );
    }

    return Layout(
      drawer: const UsuarioDrawer(),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Solicitação de Atendimento",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const Divider(),

                        const SizedBox(height: 16),

                        /// -------------------------
                        /// PROFISSIONAL
                        /// -------------------------
                        DropdownButtonFormField<Profissional>(
                          decoration: const InputDecoration(
                            labelText: 'Profissional',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          initialValue: _profissionalSelecionado,
                          items: _profissionais.map((p) {
                            return DropdownMenuItem(
                              value: p,
                              child:
                                  Text("${p.nome} (${p.profissionalTipo})"),
                            );
                          }).toList(),
                          onChanged: (v) => setState(() {
                            _profissionalSelecionado = v;
                          }),
                          validator: (v) =>
                              v == null ? 'Selecione um profissional' : null,
                        ),

                        const SizedBox(height: 20),

                        /// -------------------------
                        /// TIPO DE ATENDIMENTO
                        /// -------------------------
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Atendimento',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.medical_services),
                          ),
                          initialValue: _tipoAtendimentoSelecionado,
                          items: _tiposAtendimento.map((tipo) {
                            return DropdownMenuItem(
                              value: tipo,
                              child: Text(tipo),
                            );
                          }).toList(),
                          onChanged: (v) => setState(() {
                            _tipoAtendimentoSelecionado = v;
                          }),
                          validator: (v) =>
                              v == null ? 'Selecione um tipo' : null,
                        ),

                        const SizedBox(height: 30),

                        ElevatedButton.icon(
                          onPressed: _solicitarAtendimento,
                          icon: const Icon(Icons.send),
                          label: const Text("SOLICITAR ATENDIMENTO"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),

                        const SizedBox(height: 20),

                        //Text("ID Usuário (sessão): $_idUsuario"),
                        //Text("Profissional selecionado: ${_profissionalSelecionado?.idProfissional ?? 'nenhum'}"),
                        Text("Aguarde a confirmação do atendimento pelo profissional. Verifique sua agenda."),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
