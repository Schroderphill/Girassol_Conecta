import 'package:flutter/material.dart';
import '/components/layout.dart';
import '../../components/drawers/usuario_drawer.dart';
import '/widgets/perfil_widget.dart';
import '/services/admin_service.dart';
import '/services/auth_service.dart';

class UsuarioPerfil extends StatefulWidget {
  const UsuarioPerfil({super.key});

  @override
  State<UsuarioPerfil> createState() => _UsuarioPerfilState();
}

class _UsuarioPerfilState extends State<UsuarioPerfil> {
  final nomeController = TextEditingController();
  final nomeSocialController = TextEditingController();  
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final cpfController = TextEditingController(); // ADICIONE
  final cnsController = TextEditingController(); // ADICIONE
  final dataNascimentoController = TextEditingController(); // ADICIONE
  final contatoController = TextEditingController(); // ADICIONE

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
      final user = await AdminService.verUsuario(id: userId!);
      if (user == null) return;

      setState(() {
  
          // Os controladores são usados para preencher 
          //e editar os campos visíveis.

          nomeController.text = user['Nome'] ?? '';
          nomeSocialController.text = user['NomeSocial'] ?? '';
          cpfController.text = user['CPF'] ?? ''; // Mantive 'registroController' associado a 'CPF'
          cnsController.text = user['CNS'] ?? ''; // Novo controlador
          dataNascimentoController.text = user['DataNascimento'] ?? ''; // Novo controlador
          contatoController.text = user['Contato'] ?? ''; // Novo controlador
          emailController.text = user['Email'] ?? '';
          senhaController.text = ''; // A senha nunca deve ser preenchida para edição

          // O originalData é usado para checar se houve alguma mudança.
          
          originalData = {
            'Nome': user['Nome'],
            'NomeSocial': user['NomeSocial'],
            'CPF': user['CPF'],
            'CNS': user['CNS'],
            'DataNascimento': user['DataNascimento'],
            'Contato': user['Contato'],
            'Email': user['Email'],
            'Senha': user['Senha'], // Geralmente nulo, a menos que o backend retorne um hash
            
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
      'CPF': cpfController.text.trim(),
      'CNS': cnsController.text.trim(),
      'DataNascimento': dataNascimentoController.text.trim(),
      'Contato': contatoController.text.trim(),
      'Email': emailController.text.trim(),
      if (senhaController.text.isNotEmpty)
        'Senha': senhaController.text.trim(),
    };

    setState(() => isSaving = true);

    // Mude para o método correto do AdminServices)
    final (success, message) = await AdminService.editarUsuario(
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
        await _loadUserData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      drawer: const UsuarioDrawer(),      
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
                {'label': 'CPF', 'controller': cpfController, 'mask': '000.000.000-00', 'type': TextInputType.number},
                {'label': 'CNS (Cartão Nacional de Saúde)', 'controller': cnsController, 'type': TextInputType.number},
                {'label': 'Data de Nascimento', 'controller': dataNascimentoController, 'mask': '00/00/0000', 'type': TextInputType.datetime}, 
                {'label': 'Contato (Telefone/Celular)', 'controller': contatoController, 'mask': '(00) 00000-0000', 'type': TextInputType.phone},
                {'label': 'E-mail', 'controller': emailController, 'type': TextInputType.emailAddress},
                {'label': 'Senha (Em branco se não alterado)', 'controller': senhaController, 'obscure': true},
              ],
              onSave: isSaving ? null : _updateUserData,
            ),
          ],
        ),
      ),
    );
  }
}
