import 'package:flutter/material.dart';
import '/components/layout.dart';
import '../../components/drawers/admin_drawer.dart';
import '/widgets/perfil_widget.dart';
import '/services/admin_service.dart';
import '/services/auth_service.dart';

class AdminPerfil extends StatefulWidget {
  const AdminPerfil({super.key});

  @override
  State<AdminPerfil> createState() => _AdminPerfilState();
}

class _AdminPerfilState extends State<AdminPerfil> {
  final nomeController = TextEditingController();
  final nomeSocialController = TextEditingController();
  final registroController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  Map<String, dynamic> originalData = {};
  String? userId;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storedId = await AuthService.getUserId();
    if (storedId == null) {
      debugPrint('Nenhum ID encontrado na sessão.');
      return;
    }

    userId = storedId;
    try {
      final user = await AdminService.getProfissionalById(id: userId!);
      if (user == null) return;

      setState(() {
        nomeController.text = user['Nome'] ?? '';
        nomeSocialController.text = user['NomeSocial'] ?? '';
        registroController.text = user['Registro'] ?? '';
        emailController.text = user['Email'] ?? '';
        senhaController.text = '';

        originalData = {
          'Nome': user['Nome'],
          'NomeSocial': user['NomeSocial'],
          'Registro': user['Registro'],
          'Email': user['Email'],
        };
      });
    } catch (e) {
      debugPrint('Erro ao carregar dados do perfil: $e');
    }
  }

  Future<void> _updateUserData() async {
    if (userId == null) return;

    final Map<String, dynamic> updatedData = {
      'Nome': nomeController.text.trim(),
      'NomeSocial': nomeSocialController.text.trim(),
      'Registro': registroController.text.trim(),
      'Email': emailController.text.trim(),
      if (senhaController.text.isNotEmpty)
        'Senha': senhaController.text.trim(),
    };

    setState(() => isSaving = true);

    final (success, message) = await AdminService.editarProfissional(
      int.parse(userId!),
      updatedData,
    );

    setState(() => isSaving = false);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        await _loadUserData(); // 🔄 Recarrega dados atualizados
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      drawer: const AdminDrawer(),      
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Perfil do Usuário",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 20),
            PerfilWidget(
              title: "Dados Pessoais",
              fields: [
                {'label': 'Nome', 'controller': nomeController},
                {'label': 'Nome Social', 'controller': nomeSocialController},
                {'label': 'Registro Profissional', 'controller': registroController},
                {'label': 'E-mail', 'controller': emailController, 'type': TextInputType.emailAddress},
                {'label': 'Senha (deixe em branco para não alterar)', 'controller': senhaController, 'obscure': true},
              ],
              onSave: isSaving ? null : _updateUserData,
            ),
          ],
        ),
      ),
    );
  }
}
