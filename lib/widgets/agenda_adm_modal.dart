// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

/// =============================================================
///  MODAIS DE AGENDAMENTO - ADMIN
/// =============================================================
/// Este arquivo contém TODOS os modais usados na tela de agendas.
/// O controller (agendas_controller.dart) faz a lógica.
/// Aqui temos apenas UI.
/// =============================================================

class AgendaAdmModals {
  // =============================================================
  // 1) MODAL PARA ADICIONAR NOVO AGENDAMENTO
  // =============================================================
  static Future<void> showAddModal({
    required BuildContext context,
    required Widget profissionalDropdown,
    required Widget usuarioDropdown,
    required Widget tipoDropdown,
    required TextEditingController dataCtrl,
    required TextEditingController horaCtrl,
    required VoidCallback onSelectData,
    required VoidCallback onSelectHora,
    required VoidCallback onSave,
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Novo Agendamento",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  profissionalDropdown,
                  const SizedBox(height: 12),
                  usuarioDropdown,
                  const SizedBox(height: 12),
                  tipoDropdown,
                  const SizedBox(height: 20),

                  // DATA
                  const Text("Data:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: dataCtrl,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Selecione a data",
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: onSelectData,
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // HORA
                  const Text("Hora:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: horaCtrl,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Selecione a hora",
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: onSelectHora,
                        icon: const Icon(Icons.access_time),
                      ),
                    ],
                  ),
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
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // 2) MODAL PARA VISUALIZAR AGENDAMENTO (com opção editar)
  // =============================================================
  static Future<void> showViewModal({
    required BuildContext context,
    required String profissional,
    required String usuario,
    required String tipo,
    required String data,
    required String hora,
    required VoidCallback onEdit,
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Detalhes do Agendamento",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _info("Profissional:", profissional),
                _info("Usuário:", usuario),
                _info("Tipo:", tipo),
                _info("Data:", data),
                _info("Hora:", hora),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: onEdit,
              child: const Text("Editar"),
            ),
            TextButton(
              child: const Text("Fechar"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // 3) MODAL PARA EDITAR AGENDAMENTO
  // =============================================================
  static Future<void> showEditModal({
    required BuildContext context,
    required TextEditingController dataCtrl,
    required TextEditingController horaCtrl,
    required VoidCallback onSelectData,
    required VoidCallback onSelectHora,
    required VoidCallback onSave,
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Editar Agendamento",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Data:", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dataCtrl,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onSelectData,
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("Hora:", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: horaCtrl,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onSelectHora,
                      icon: const Icon(Icons.access_time),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              
              onPressed: onSave,
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  //============================================================
  //MODAL FINALIZAR ATENDIMENTO
  //============================================================

  static Future<void> showFinalizeModal({
    required BuildContext context,
    required TextEditingController anotaAtendimentoCtrl,
    //required TextEditingController horaCtrl,
    //required VoidCallback onSelectData,
    //required VoidCallback onSelectHora,
    required VoidCallback onSave,
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Atender Usuario",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Anotações da Sessão:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10), //espaçamento
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: anotaAtendimentoCtrl,
                        //readOnly: true,
                        maxLines: 5, // Adicionado: Suporte a múltiplas linhas para anotações
                        keyboardType: TextInputType.multiline, // Adicionado: Teclado adaptado
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                ],
                ),
                const SizedBox(height: 20),                               
              ],
            ),
          ),
          actions: [
            TextButton(
              
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              
              onPressed: onSave,
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

//============================================================
  //MODAL VER  PRONTUÁRIO
  //============================================================

  static Future<void> showProntuarioModal({
    required BuildContext context,
    required TextEditingController anotaAtendimentoCtrl,    
   // required VoidCallback onSave,
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Prontuário do Atendimento",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Anotações da Sessão:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10), //espaçamento
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: anotaAtendimentoCtrl,
                        //readOnly: true,
                        maxLines: 5, // Adicionado: Suporte a múltiplas linhas para anotações
                        keyboardType: TextInputType.multiline, // Adicionado: Teclado adaptado
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                ],
                ),
                const SizedBox(height: 20),                               
              ],
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
  // 4) MODAL DE CANCELAMENTO DO AGENDAMENTO
  // =============================================================
  static Future<void> showCancelModal({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Cancelar Agendamento",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Tem certeza que deseja cancelar este atendimento?\n\n"
            "O status será definido como: CANCELADO.",
          ),
          actions: [
            TextButton(
              
              onPressed: () => Navigator.pop(context),
              child: const Text("Não"),
            ),
            ElevatedButton(
              
              onPressed: onConfirm,
              child: const Text("Sim, cancelar"),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // WIDGET UTILITÁRIO
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
}