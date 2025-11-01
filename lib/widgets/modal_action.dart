import 'package:flutter/material.dart';

/// Classe utilitária para exibir modais genéricos (visualização, edição, adição, exclusão)
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

  /// Modal de edição (retorna os dados editados)
static Future<Map<String, dynamic>?> showEditModal(
  BuildContext context, Map<String, dynamic> data) async {

  final nomeController = TextEditingController(text: data['Nome']?.toString() ?? '');
  final nomeSocialController = TextEditingController(text: data['NomeSocial']?.toString() ?? '');
  final registroController = TextEditingController(text: data['Registro']?.toString() ?? '');
  final emailController = TextEditingController(text: data['Email']?.toString() ?? '');
  final senhaController = TextEditingController();
  String tipo = data['ProfissionalTipo']?.toString() ?? 'Medico';
  bool isAdmin = data['IDProfissionalADM'] != null && data['IDProfissionalADM'].toString().isNotEmpty;

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Editar Profissional'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome completo'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nomeSocialController,
                  decoration: const InputDecoration(labelText: 'Nome social'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: registroController,
                  decoration: const InputDecoration(labelText: 'Registro profissional'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: tipo,
                  decoration: const InputDecoration(labelText: 'Tipo de profissional'),
                  items: const [
                    DropdownMenuItem(value: 'Medico', child: Text('Médico')),
                    DropdownMenuItem(value: 'Psicologo', child: Text('Psicólogo')),
                    DropdownMenuItem(value: 'AssistenteSocial', child: Text('Assistente Social')),
                  ],
                  onChanged: (value) => setState(() => tipo = value!),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Nova senha (opcional)'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: isAdmin,
                      onChanged: (v) => setState(() => isAdmin = v ?? false),
                    ),
                    const Text('Administrador do sistema'),
                  ],
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
              onPressed: () async {
                if (nomeController.text.isEmpty ||
                    registroController.text.isEmpty ||
                    emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
                  );
                  return;
                }

                String? senhaCriptografada;
                if (senhaController.text.isNotEmpty) {
                  senhaCriptografada = senhaController.text; // será criptografada na API
                }

                Navigator.pop(context, {
                  'idProfissional': data['idProfissional'],
                  'Nome': nomeController.text,
                  'NomeSocial': nomeSocialController.text,
                  'ProfissionalTipo': tipo,
                  'Registro': registroController.text,
                  'Email': emailController.text,
                  'Senha': senhaCriptografada,
                  'IDProfissionalADM': isAdmin ? data['idProfissional'] : '',
                });
              },
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      );
    },
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
static Future<Map<String, dynamic>?> showAddModal(BuildContext context) async {
  final nomeController = TextEditingController();
  final nomeSocialController = TextEditingController();
  final registroController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  String tipo = 'Medico'; // valor padrão

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
              decoration: const InputDecoration(labelText: 'Nome completo'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nomeSocialController,
              decoration: const InputDecoration(labelText: 'Nome social (opcional)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: registroController,
              decoration: const InputDecoration(labelText: 'Registro profissional'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: tipo,
              decoration: const InputDecoration(labelText: 'Tipo de profissional'),
              items: const [
                DropdownMenuItem(value: 'Medico', child: Text('Médico')),
                DropdownMenuItem(value: 'Psicologo', child: Text('Psicólogo')),
                DropdownMenuItem(value: 'AssistenteSocial', child: Text('Assistente Social')),
              ],
              onChanged: (value) => tipo = value!,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
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
                registroController.text.isEmpty ||
                emailController.text.isEmpty ||
                senhaController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
              );
              return;
            }

            Navigator.pop(context, {
              'Nome': nomeController.text,
              'NomeSocial': nomeSocialController.text.isEmpty
                  ? null
                  : nomeSocialController.text,
              'ProfissionalTipo': tipo,
              'Registro': registroController.text,
              'Email': emailController.text,
              'Senha': senhaController.text, // API faz password_hash
              'IDProfissionalADM': null, // 🔹 Sempre NULL no cadastro
            });
          },
          child: const Text('Cadastrar'),
        ),
      ],
    ),
  );


  }
}
