import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2)); // tempo da splash
    bool isLoggedIn = await AuthService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // Recuperar a role salva no login
      final prefs = await SharedPreferences.getInstance();
      String role = prefs.getString('userRole') ?? 'usuario';

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
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // padronizado
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wb_sunny, size: 80, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'Girassol Conecta',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
