// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/services/admin_service.dart';
import '/widgets/user_adm_modal.dart';

class UsuariosController {
  /// Controla todas as ações (ver, editar, excluir, adicionar)
  static Future<void> handleAction(
    BuildContext context, {
    required String action,
    required Map<String, dynamic> usuario,
    required VoidCallback onRefresh,
  }) async {
    switch (action) {
      case 'ver':
        await _verUsuario(context, usuario);
        break;

      case 'editar':
        await _editarUsuario(context, usuario, onRefresh);
        break;

      case 'excluir':
        await _excluirUsuario(context, usuario, onRefresh);
        break;

      case 'adicionar':
        await _adicionarUsuario(context, onRefresh);
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ação desconhecida.')),
        );
    }
  }

  // 🟢 VISUALIZAR USUÁRIO
  static Future<void> _verUsuario(
      BuildContext context, Map<String, dynamic> usuario) async {
    await UserAdmModal.showViewModal(context, usuario);
  }

  // 🟡 EDITAR USUÁRIO
  static Future<void> _editarUsuario(
      BuildContext context, Map<String, dynamic> usuario, VoidCallback onRefresh) async {
    final updated = await UserAdmModal.showEditModal(context, usuario);
    if (updated == null) return;

    final id = int.tryParse(usuario['idUsuario'].toString()) ?? 0;
    final (ok, msg) = await AdminService.editarUsuario(id, updated);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );

    if (ok) onRefresh();
  }

  // 🔴 EXCLUIR USUÁRIO
  static Future<void> _excluirUsuario(
      BuildContext context, Map<String, dynamic> usuario, VoidCallback onRefresh) async {
    final nome = usuario['Nome'] ?? 'este usuário';
    final confirm = await UserAdmModal.showDeleteConfirm(context, nome);
    if (!confirm) return;

    final id = int.tryParse(usuario['idUsuario'].toString()) ?? 0;
    final (ok, msg) = await AdminService.excluirUsuario(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );

    if (ok) onRefresh();
  }

  // 🟢 ADICIONAR NOVO USUÁRIO
  static Future<void> _adicionarUsuario(
      BuildContext context, VoidCallback onRefresh) async {
    final result = await UserAdmModal.showAddModal(context);
    if (result == null) return;

    final (ok, msg) = await AdminService.cadastrarUsuario(result);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );

    if (ok) onRefresh();
  }
}
