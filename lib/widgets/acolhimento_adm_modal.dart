// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

/// =============================================================
///   MODAIS DE ACOLHIMENTO - ADMIN
/// =============================================================
/// Este arquivo contém os modais usados na tela de AdmAcolhimentoScreen.
/// Foca na UI para visualização, criação e edição dos dados socioeconômicos
/// e de núcleo familiar.
/// =============================================================

class AcolhimentoAdmModals {
  
  // =============================================================
  // WIDGET UTILITÁRIO (Replicado do modelo)
  // =============================================================
  static Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(text: "$label ", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // 1) MODAL PARA VISUALIZAR ACOLHIMENTO (Dados Socioeconômicos e Familiar)
  // (Mantido do seu modelo original)
  // =============================================================
  static Future<void> showAcolhimentoModal({
    required BuildContext context,
    required String nomeUsuario,
    required String profissional,
    required String data,
    required String hora,
    required List<Widget> familiarDataWidgets,
    required List<Widget> economicoDataWidgets,
    required VoidCallback onEditFamiliar,
    required VoidCallback onEditEconomico,
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            "Detalhes do Acolhimento - $nomeUsuario",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 600, // Maior largura para acomodar mais dados
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Informações Básicas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
                  const Divider(),
                  _info("Profissional:", profissional),
                  _info("Data/Hora:", "$data às $hora"),
                  
                  const SizedBox(height: 16),

                  // NÚCLEO FAMILIAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Núcleo Familiar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                      IconButton(
                        onPressed: onEditFamiliar,
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        tooltip: 'Editar Núcleo Familiar',
                      ),
                    ],
                  ),
                  const Divider(),
                  ...familiarDataWidgets, // Lista de Widgets para dados familiares
                  
                  const SizedBox(height: 24),

                  // DADOS SOCIOECONÔMICOS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Dados Socioeconômicos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                      IconButton(
                        onPressed: onEditEconomico,
                        icon: const Icon(Icons.edit, color: Colors.green, size: 20),
                        tooltip: 'Editar Dados Socioeconômicos',
                      ),
                    ],
                  ),
                  const Divider(),
                  ...economicoDataWidgets, // Lista de Widgets para dados econômicos
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // 2) MODAL PARA CRIAÇÃO DE NÚCLEO FAMILIAR (NOVO)
  // =============================================================
  static Future<void> showCreateFamiliarModal({
    required BuildContext context,
    required String nomeUsuario,
    required List<Widget> formFields, // Campos de formulário para criação
    required VoidCallback onSave,
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            "Adicionar Membro Familiar para $nomeUsuario",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          content: SizedBox(
            width: 450, 
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...formFields, // Formulário com os campos de criação
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Cadastrar Membro"),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // 3) MODAL PARA EDIÇÃO DE NÚCLEO FAMILIAR (ATUALIZADO DO SEU MODELO)
  // =============================================================
  static Future<void> showEditFamiliarModal({
    required BuildContext context,
    required String nomeUsuario,
    required List<Widget> formFields, // Campos de formulário para edição
    required VoidCallback onSave,
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            "Editar Núcleo Familiar de $nomeUsuario",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 450, 
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...formFields, // Formulário com os campos de edição
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: onSave,
              child: const Text("Salvar Alterações"),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // 4) MODAL PARA CRIAÇÃO DE CADASTRO SOCIOECONÔMICO (NOVO)
  // =============================================================
  static Future<void> showCreateEconomicoModal({
    required BuildContext context,
    required String nomeUsuario,
    required List<Widget> formFields, // Campos de formulário para criação
    required VoidCallback onSave,
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            "Cadastro Socioeconômico para $nomeUsuario",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          content: SizedBox(
            width: 550, // Um pouco maior para os campos de endereço
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...formFields, // Formulário com os campos de criação
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Cadastrar Dados"),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // 5) MODAL PARA EDIÇÃO DE CADASTRO SOCIOECONÔMICO (ATUALIZADO DO SEU MODELO)
  // =============================================================
  static Future<void> showEditEconomicoModal({
    required BuildContext context,
    required String nomeUsuario,
    required List<Widget> formFields, // Campos de formulário para edição
    required VoidCallback onSave,
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            "Editar Dados Socioeconômicos de $nomeUsuario",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 550, 
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...formFields, // Formulário com os campos de edição
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: onSave,
              child: const Text("Salvar Alterações"),
            ),
          ],
        );
      },
    );
  }

   // =============================================================
  // 4) MODAL DE FINALIZAÇÃO DO AGENDAMENTO
  // =============================================================
  static Future<void> showFimAcolhimentoModal({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Finalizar Acolhimento",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Tem certeza que deseja finalizar este acolhimento?\n\n"
            "O status será definido como: FINALIZADO.",
          ),
          actions: [
            TextButton(
              
              onPressed: () => Navigator.pop(context),
              child: const Text("Não"),
            ),
            ElevatedButton(
              
              onPressed: onConfirm,
              child: const Text("Sim, Finalizar"),
            ),
          ],
        );
      },
    );
  }

}