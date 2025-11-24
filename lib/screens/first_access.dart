// lib/components/first_access/first_access_controller.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../services/agenda_service.dart';
//import '../services/auth_service.dart';
import '../widgets/first_access_modal.dart';

class FirstAccessController extends StatefulWidget {
  final Map<String, dynamic> user; // dados vindos do login
  final Widget child;              // tela que deve abrir se tudo estiver ok

  const FirstAccessController({
    super.key,
    required this.user,
    required this.child,
  });

  @override
  State<FirstAccessController> createState() => _FirstAccessControllerState();
}

class _FirstAccessControllerState extends State<FirstAccessController> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _runFlow();
  }

  Future<void> _runFlow() async {
    final user = widget.user;

    // 1️⃣ Verificar termo de uso
    if (user['TermoUso'] != 'Sim') {
      await showTermsModal(context, user);
    }

    // 2️⃣ Verificar se já existe atendimento
    final agendaService = AgendaService();

    final atendimentos = await agendaService.fetchAgendas(
      filtros: {
        "Usuario_idUsuario": user['idUsuario'].toString(),
      },
    );

    final bool temAtendimento = atendimentos.isNotEmpty;

    // Se não tiver nenhum → primeira solicitação obrigatória
    if (!temAtendimento) {
      await showFirstSolicitacaoModal(context, user);
    }

    // Marca como finalizado
    setState(() => _loaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 🔥 Quando o fluxo terminar, libera a navegação normal
    return widget.child;
  }

  
}
