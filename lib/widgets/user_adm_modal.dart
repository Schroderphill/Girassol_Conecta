import 'package:flutter/material.dart';

/// Modais para Usuário — segue exatamente o padrão do ModalAction (Profissionais)
/// Campos alinhados com a base: idUsuario, Nome, NomeSocial, CPF, CNS, DataNascimento,
/// Contato, Email, Senha, UseridVoluntario
class UserAdmModal {
  /// 🟢 Modal de visualização simples
  static Future<void> showViewModal(
      BuildContext context, Map<String, dynamic> data) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalhes do Usuário'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: data.entries
                .map(
                  (e) => ListTile(
                    dense: true,
                    title: Text(
                      e.key.toString().toUpperCase(),
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

  /// ✏️ Modal de edição (retorna Map com os dados editados)
  static Future<Map<String, dynamic>?> showEditModal(
      BuildContext context, Map<String, dynamic> data) async {
    // Controladores com valores iniciais vindos do registro
    final nomeController =
        TextEditingController(text: data['Nome']?.toString() ?? '');
    final nomeSocialController =
        TextEditingController(text: data['NomeSocial']?.toString() ?? '');
    final cpfController =
        TextEditingController(text: data['CPF']?.toString() ?? '');
    final cnsController =
        TextEditingController(text: data['CNS']?.toString() ?? '');
    final dataNascimentoController =
        TextEditingController(text: data['DataNascimento']?.toString() ?? '');
    final contatoController =
        TextEditingController(text: data['Contato']?.toString() ?? '');
    final emailController =
        TextEditingController(text: data['Email']?.toString() ?? '');
    final senhaController = TextEditingController(); // senha nova (opcional)
    final useridVoluntarioController = TextEditingController(
        text: data['UseridVoluntario']?.toString() ?? '');

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Editar Usuário'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nome
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Nome completo'),
                  ),
                  const SizedBox(height: 10),

                  // Nome social
                  TextField(
                    controller: nomeSocialController,
                    decoration: const InputDecoration(labelText: 'NomeSocial'),
                  ),
                  const SizedBox(height: 10),

                  // CPF
                  TextField(
                    controller: cpfController,
                    decoration: const InputDecoration(labelText: 'CPF'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),

                  // CNS
                  TextField(
                    controller: cnsController,
                    decoration: const InputDecoration(labelText: 'CNS'),
                  ),
                  const SizedBox(height: 10),

                  // DataNascimento
                  TextField(
                    controller: dataNascimentoController,
                    decoration: const InputDecoration(
                      labelText: 'DataNascimento',
                      hintText: 'YYYY-MM-DD',
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 10),

                  // Contato
                  TextField(
                    controller: contatoController,
                    decoration: const InputDecoration(labelText: 'Contato'),
                  ),
                  const SizedBox(height: 10),

                  // Email
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),

                  // Senha (opcional — se preenchida, envia para API para alteração)
                  TextField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Senha (nova, opcional)'),
                  ),
                  const SizedBox(height: 10),

                  // UseridVoluntario (campo que referencia voluntário — pode ser vazio)
                  TextField(
                    controller: useridVoluntarioController,
                    decoration:
                        const InputDecoration(labelText: 'UseridVoluntario (id ou vazio)'),
                    keyboardType: TextInputType.number,
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
                  // Validações mínimas (seguir padrão do ModalAction — exige nome e CPF)
                  if (nomeController.text.isEmpty || cpfController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha Nome e CPF.')),
                    );
                    return;
                  }

                  // Se senha vazia, enviar null (API decide se altera)
                  final senhaEnviar =
                      senhaController.text.isNotEmpty ? senhaController.text : null;

                  Navigator.pop(context, {
                    'idUsuario': data['idUsuario'],
                    'Nome': nomeController.text,
                    'NomeSocial': nomeSocialController.text.isEmpty
                        ? null
                        : nomeSocialController.text,
                    'CPF': cpfController.text,
                    'CNS': cnsController.text.isEmpty ? null : cnsController.text,
                    'DataNascimento': dataNascimentoController.text.isEmpty
                        ? null
                        : dataNascimentoController.text,
                    'Contato': contatoController.text.isEmpty ? null : contatoController.text,
                    'Email': emailController.text.isEmpty ? null : emailController.text,
                    'Senha': senhaEnviar, // null se não houver alteração
                    'UseridVoluntario': useridVoluntarioController.text.isEmpty
                        ? null
                        : useridVoluntarioController.text,
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
        title: const Text('Excluir Usuário'),
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

  /// 🟢 Modal para adicionar um novo usuário (retorna Map com os campos)
  static Future<Map<String, dynamic>?> showAddModal(BuildContext context) async {
    final nomeController = TextEditingController();
    final nomeSocialController = TextEditingController();
    final cpfController = TextEditingController();
    final cnsController = TextEditingController();
    final dataNascimentoController = TextEditingController();
    final contatoController = TextEditingController();
    final emailController = TextEditingController();
    final senhaController = TextEditingController();
    final useridVoluntarioController = TextEditingController();

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Cadastrar Novo Usuário'),
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
                  decoration: const InputDecoration(labelText: 'NomeSocial (opcional)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cpfController,
                  decoration: const InputDecoration(labelText: 'CPF'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cnsController,
                  decoration: const InputDecoration(labelText: 'CNS (opcional)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dataNascimentoController,
                  decoration: const InputDecoration(
                    labelText: 'DataNascimento',
                    hintText: 'YYYY-MM-DD',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contatoController,
                  decoration: const InputDecoration(labelText: 'Contato (opcional)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: useridVoluntarioController,
                  decoration:
                      const InputDecoration(labelText: 'UseridVoluntario (id ou vazio)'),
                  keyboardType: TextInputType.number,
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
                    cpfController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    senhaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha os campos obrigatórios.')),
                  );
                  return;
                }

                Navigator.pop(context, {
                  // idUsuario não é enviado no cadastro (será gerado no backend)
                  'Nome': nomeController.text,
                  'NomeSocial':
                      nomeSocialController.text.isEmpty ? null : nomeSocialController.text,
                  'CPF': cpfController.text,
                  'CNS': cnsController.text.isEmpty ? null : cnsController.text,
                  'DataNascimento':
                      dataNascimentoController.text.isEmpty ? null : dataNascimentoController.text,
                  'Contato': contatoController.text.isEmpty ? null : contatoController.text,
                  'Email': emailController.text,
                  'Senha': senhaController.text,
                  'UseridVoluntario': useridVoluntarioController.text.isEmpty
                      ? null
                      : useridVoluntarioController.text,
                });
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
