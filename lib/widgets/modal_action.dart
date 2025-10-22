import 'package:flutter/material.dart';

/// 🔹 Classe utilitária para exibir modais genéricos (visualização, edição, adição, exclusão)
/// Os modais são independentes e retornam os dados ao Controller.
/// A lógica de CRUD é centralizada no `ProfissionaisController`.
class ModalAction {
  /// 🟢 Modal de visualização simples
  static Future<void> showViewModal(
      BuildContext context, Map<String, dynamic> data) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalhes do Profissional'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: data.entries
                .map(
                  (e) => ListTile(
                    dense: true,
                    title: Text(
                      e.key.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(e.value?.toString() ?? '-'),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  /// 🟡 Modal de edição (retorna os dados editados)
  static Future<Map<String, dynamic>?> showEditModal(
      BuildContext context, Map<String, dynamic> data) async {
    final nomeController =
        TextEditingController(text: data['nome']?.toString() ?? '');
    final registroController =
        TextEditingController(text: data['registro']?.toString() ?? '');
    String especialidade = data['especialidade']?.toString() ?? 'medico';

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Profissional'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: registroController,
                decoration:
                    const InputDecoration(labelText: 'Registro Profissional'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: especialidade,
                decoration: const InputDecoration(labelText: 'Especialidade'),
                items: const [
                  DropdownMenuItem(value: 'Medico', child: Text('Médico')),
                  DropdownMenuItem(value: 'Psicologo', child: Text('Psicólogo')),
                  DropdownMenuItem(
                      value: 'assistentesocial',
                      child: Text('Assistente Social')),
                ],
                onChanged: (value) => especialidade = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nomeController.text.isEmpty ||
                  registroController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Preencha todos os campos obrigatórios.')),
                );
                return;
              }

              Navigator.pop(context, {
                'id': data['id'],
                'nome': nomeController.text,
                'registro': registroController.text,
                'especialidade': especialidade,
              });
            },
            child: const Text('Salvar Alterações'),
          ),
        ],
      ),
    );
  }

  /// 🔴 Modal de confirmação de exclusão
  static Future<bool> showDeleteConfirm(
      BuildContext context, String nome) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Profissional'),
        content: Text('Deseja realmente excluir "$nome"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// 🟢 Modal para adicionar um novo profissional
  /// Retorna os dados preenchidos no formulário.
  static Future<Map<String, dynamic>?> showAddModal(
      BuildContext context) async {
    final nomeController = TextEditingController();
    final registroController = TextEditingController();
    String especialidade = 'medico'; // valor padrão

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cadastrar Novo Profissional'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: registroController,
                decoration: const InputDecoration(
                    labelText: 'Registro Profissional'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: especialidade,
                decoration: const InputDecoration(labelText: 'Especialidade'),
                items: const [
                  DropdownMenuItem(value: 'medico', child: Text('Médico')),
                  DropdownMenuItem(value: 'psicologo', child: Text('Psicólogo')),
                  DropdownMenuItem(
                      value: 'assistentesocial',
                      child: Text('Assistente Social')),
                ],
                onChanged: (value) => especialidade = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nomeController.text.isEmpty ||
                  registroController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Preencha todos os campos obrigatórios.')),
                );
                return;
              }

              Navigator.pop(context, {
                'nome': nomeController.text,
                'registro': registroController.text,
                'especialidade': especialidade,
              });
            },
            child: const Text('Cadastrar'),
          ),
        ],
      ),
    );
  }
}
