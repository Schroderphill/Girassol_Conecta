import 'package:flutter/material.dart';
import '/components/layout.dart';
import '../../components/drawers/admin_drawer.dart';
import '/widgets/perfil_widget.dart';
import '/services/admin_service.dart';
import '/services/auth_service.dart'; // ✅ import para usar getUserId()

class AdminPerfil extends StatefulWidget {
  const AdminPerfil({super.key});

  @override
  State<AdminPerfil> createState() => _AdminPerfilState();
}

class _AdminPerfilState extends State<AdminPerfil> {
  final nomeController = TextEditingController();
  final nomeSocialController = TextEditingController();
  final profissionalTipoController = TextEditingController();
  final registroController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  Map<String, dynamic> originalData = {};
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    //Obtém o ID da sessão de forma segura (int -> string)
    final storedId = await AuthService.getUserId();
    if (storedId == null) {
      debugPrint('Nenhum ID encontrado na sessão.');
      return;
    }

    userId = storedId; // já vem como string
    try {
      final user = await AdminService.getProfissionalById(id: userId!);
      if (user == null) return;

      setState(() {
        nomeController.text = user['Nome'] ?? '';
        nomeSocialController.text = user['NomeSocial'] ?? '';
        profissionalTipoController.text = user['ProfissionalTipo'] ?? '';
        registroController.text = user['Registro'] ?? '';
        emailController.text = user['Email'] ?? '';
        senhaController.text = ''; // senha sempre vazia

        originalData = {
          'Nome': user['Nome'],
          'NomeSocial': user['NomeSocial'],
          'ProfissionalTipo': user['ProfissionalTipo'],
          'Registro': user['Registro'],
          'Email': user['Email'],
        };
      });
    } catch (e) {
      debugPrint('Erro ao carregar dados do perfil: $e');
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
              title: "Dados Pessoais e Profissionais",
              fields: [
                {'label': 'Nome', 'controller': nomeController},
                {'label': 'Nome Social', 'controller': nomeSocialController},
                {'label': 'Tipo de Profissional', 'controller': profissionalTipoController},
                {'label': 'Registro Profissional', 'controller': registroController},
                {'label': 'E-mail', 'controller': emailController, 'type': TextInputType.emailAddress},
                {'label': 'Senha (deixe em branco para não alterar)', 'controller': senhaController, 'obscure': true},
              ],
              // onSave: _updateUserData,
            ),
          ],
        ),
      ),
    );
  }
}
