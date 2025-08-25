import 'package:flutter/material.dart';
import '../widgets/sunflower_icon.dart';
import '../theme/app_colors.dart';

class Dashboard extends StatelessWidget {
  final VoidCallback onLogout;

  const Dashboard({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'title': 'Usuários Totais',
        'value': '1.234',
        'icon': Icons.people,
        'trend': '+12%',
        'description': 'usuários cadastrados'
      },
      {
        'title': 'Atividade Mensal',
        'value': '858',
        'icon': Icons.show_chart,
        'trend': '+8%',
        'description': 'acessos este mês'
      },
      {
        'title': 'Crescimento',
        'value': '24',
        'icon': Icons.trending_up,
        'trend': '+15%',
        'description': 'novos usuários hoje'
      },
      {
        'title': 'Engajamento',
        'value': '97%',
        'icon': Icons.bar_chart,
        'trend': '+3%',
        'description': 'taxa de satisfação'
      }
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.girassolBg, AppColors.girassolLight],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              color: AppColors.card.withOpacity(0.8),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const SunflowerIcon(size: 40),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Girassol Conecta',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.girassolDark,
                              ),
                            ),
                            Text(
                              'Dashboard Administrativo',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.girassolMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: onLogout,
                        child: const Text(
                          'Sair',
                          style: TextStyle(color: AppColors.girassolMuted),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    const Text(
                      'Bem-vindo de volta!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.girassolDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Aqui estão suas métricas e estatísticas mais recentes.',
                      style: TextStyle(color: AppColors.girassolMuted),
                    ),
                    const SizedBox(height: 24),

                    // Stats Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: stats.length,
                      itemBuilder: (context, index) {
                        final stat = stats[index];
                        return Card(
                          elevation: 4,
                         // color: AppColors.card.withOpacity(0.95),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      stat['title'] as String,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.girassolMuted,
                                      ),
                                    ),
                                    Icon(
                                      stat['icon'] as IconData,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  stat['value'] as String,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.girassolDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      stat['trend'] as String,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      stat['description'] as String,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.girassolMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
