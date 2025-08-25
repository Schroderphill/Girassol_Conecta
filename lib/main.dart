import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_page.dart';
import 'screens/dashboard.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Girassol Conecta',
      theme: AppTheme.theme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isLoggedIn = false;

  void _handleLogin(String email, String password) async {
    setState(() => _isLoading = true);

    final success = await _authService.login(email, password);

    if (!mounted) return; // Adicione este check

    setState(() {
      _isLoading = false;
      _isLoggedIn = success;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Login realizado com sucesso!'
            : 'Credenciais inválidas.'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  void _handleLogout() {
    _authService.logout();
    setState(() => _isLoggedIn = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout realizado. Até logo!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _isLoggedIn
        ? Dashboard(onLogout: _handleLogout)
        : LoginPage(onLogin: _handleLogin);
  }
}
