import 'package:flutter/material.dart';
import '../widgets/sunflower_icon.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _nomeSocialController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cnsController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _contatoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool loading = false;
  bool isLogin = true; // alterna entre login/cadastro

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    Map<String, dynamic> result;

    if (isLogin) {
      result = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );
    } else {
      result = await AuthService.register(
        _nameController.text,
        _nomeSocialController.text,
        _cpfController.text,
        _cnsController.text,
        _dataNascimentoController.text,
        _contatoController.text,
        _emailController.text,
        _passwordController.text,
      );
    }

    setState(() => loading = false);

    if (!mounted) return;

    if (result["success"] == true) {
      String role = result["role"] ?? "usuario";

      switch (role) {
        case "admin":
          Navigator.pushReplacementNamed(context, '/admin');
          break;
        case "profissional":
          Navigator.pushReplacementNamed(context, '/profissional');
          break;
        case "voluntario":
          Navigator.pushReplacementNamed(context, '/voluntario');
          break;
        case "usuario":
        default:
          Navigator.pushReplacementNamed(context, '/usuario');
          break;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"] ?? (isLogin ? "Falha no login" : "Falha no cadastro")),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.background, AppColors.surface],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: Theme.of(context).cardTheme.elevation,
              shape: Theme.of(context).cardTheme.shape,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SunflowerIcon(size: 64),
                      const SizedBox(height: 24),                      
                      Text(
                        isLogin ? 'Login' : 'Cadastro',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),                    
                      Text(
                        isLogin
                            ? 'Entre para continuar'
                            : 'Crie sua conta para continuar',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),
                     
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isLogin) ...[
                              // Nome
                              Text('Nome', style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(hintText: 'Seu nome completo'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu nome';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Nome Social
                              Text('Nome Social', style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nomeSocialController,
                                decoration: const InputDecoration(hintText: 'Nome social (opcional)'),
                              ),
                              const SizedBox(height: 16),

                              // CPF
                              Text('CPF', style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _cpfController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(hintText: '000.000.000-00'),
                              ),
                              const SizedBox(height: 16),

                              // CNS
                              Text('CNS', style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _cnsController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(hintText: 'Número do CNS'),
                              ),
                              const SizedBox(height: 16),

                              // Data de Nascimento
                              Text('Data de Nascimento', style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _dataNascimentoController,
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(hintText: 'dd/mm/aaaa'),
                              ),
                              const SizedBox(height: 16),

                              // Contato
                              Text('Contato', style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _contatoController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(hintText: '(00) 00000-0000'),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Email
                            Text('Email', style: Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(hintText: 'seu@email.com'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira seu email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Email inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Senha
                            Text('Senha', style: Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira sua senha';
                                }
                                if (value.length < 6) {
                                  return 'Senha deve ter ao menos 6 caracteres';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: loading ? null : _handleSubmit,
                                child: loading
                                    ? const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      )
                                    : Text(isLogin ? 'Entrar' : 'Cadastrar'),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Center(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                },
                                child: Text(
                                  isLogin
                                      ? 'Não tem conta? Registre-se'
                                      : 'Já tem conta? Entrar',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
