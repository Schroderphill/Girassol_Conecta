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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool loading = false;
  bool isLogin = true; // ✅ alterna entre login/cadastro

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    bool success = false;
    if (isLogin) {
      // Login
      success = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );
    } else {
      // Cadastro
      success = await AuthService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
    }

    setState(() => loading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isLogin ? "Falha no login" : "Falha no cadastro"),
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
            colors: [AppColors.girassolBg, AppColors.girassolLight],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              color: AppColors.card.withOpacity(0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.girassolDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isLogin
                            ? 'Entre para continuar'
                            : 'Crie sua conta para continuar',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.girassolMuted,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 🔹 Formulário dinâmico
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isLogin) ...[
                              const Text(
                                'Nome',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.girassolDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  hintText: 'Seu nome completo',
                                ),
                                validator: (value) {
                                  if (!isLogin &&
                                      (value == null || value.isEmpty)) {
                                    return 'Por favor, insira seu nome';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                            ],

                            const Text(
                              'Email',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.girassolDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'seu@email.com',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira seu email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Email inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            const Text(
                              'Senha',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.girassolDark,
                              ),
                            ),
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
                                    color: AppColors.girassolMuted,
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

                            // 🔹 Botão
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: loading ? null : _handleSubmit,
                                child: loading
                                    ? const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      )
                                    : Text(
                                        isLogin ? 'Entrar' : 'Cadastrar',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 🔹 Alternar entre login e cadastro
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
                                  style: const TextStyle(
                                    color: AppColors.girassolMuted,
                                  ),
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
