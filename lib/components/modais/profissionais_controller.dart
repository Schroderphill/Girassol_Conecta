// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/services/admin_service.dart';
import '/widgets/modal_action.dart';

class ProfissionaisController {
  /// Controla todas as ações (ver, editar, excluir, adicionar)
  static Future<void> handleAction(
    BuildContext context, {
    required String action,
    required Map<String, dynamic> profissional,
    required VoidCallback onRefresh,
  }) async {
    switch (action) {
      case 'ver':
        await _verProfissional(context, profissional);
        break;

      case 'editar':
        await _editarProfissional(context, profissional, onRefresh);
        break;

      case 'excluir':
        await _excluirProfissional(context, profissional, onRefresh);
        break;

      case 'adicionar':
        await _adicionarProfissional(context, onRefresh);
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ação desconhecida.')),
        );
    }
  }

  /// 🟢 VISUALIZAR PROFISSIONAL
  static Future<void> _verProfissional(
      BuildContext context, Map<String, dynamic> profissional) async {
    await ModalAction.showViewModal(context, profissional);
  }

  /// 🟡 EDITAR PROFISSIONAL
  static Future<void> _editarProfissional(
      BuildContext context, Map<String, dynamic> profissional, VoidCallback onRefresh) async {
    final updated = await ModalAction.showEditModal(context, profissional);
    if (updated == null) return;

    final id = int.tryParse(profissional['idProfissional'].toString()) ?? 0;
    final (ok, msg) = await AdminService.editarProfissional(id, updated);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );

    if (ok) onRefresh();
  }

  /// 🔴 EXCLUIR PROFISSIONAL
  static Future<void> _excluirProfissional(
      BuildContext context, Map<String, dynamic> profissional, VoidCallback onRefresh) async {
    final nome = profissional['Nome'] ?? 'este profissional';
    final confirm = await ModalAction.showDeleteConfirm(context, nome);
    if (!confirm) return;

    final id = int.tryParse(profissional['idProfissional'].toString()) ?? 0;
    final (ok, msg) = await AdminService.excluirProfissional(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );

    if (ok) onRefresh();
  }

  /// 🟢 ADICIONAR NOVO PROFISSIONAL
  static Future<void> _adicionarProfissional(
    BuildContext context, VoidCallback onRefresh) async {

  // Agora usa o modal correto:
  final result = await ModalAction.showAddModal(context);
  if (result == null) return;

  // Desestruturar o record (bool ok, String msg)
  final (ok, msg) = await AdminService.cadastrarProfissional(result);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: ok ? Colors.green : Colors.red,
    ),
  );

  if (ok) onRefresh();
}
}
