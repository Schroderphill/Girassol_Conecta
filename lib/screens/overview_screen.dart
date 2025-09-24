import 'package:flutter/material.dart';
import '../components/layout.dart';
import '../widgets/summary_card.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Visão Geral",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            // Grid de cards -> navegação entre módulos
            Expanded(
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  SummaryCard(
                    title: "Acolhimento",
                    description: "Gerir atendimentos iniciais",
                    icon: Icons.favorite_border,
                    onTap: () => Navigator.pushReplacementNamed(context, '/acolhimento'),
                  ),
                  SummaryCard(
                    title: "Voluntários",
                    description: "Cadastrar e acompanhar",
                    icon: Icons.group_outlined,
                    onTap: () => Navigator.pushReplacementNamed(context, '/voluntarios'),
                  ),
                  SummaryCard(
                    title: "Profissionais",
                    description: "Gerenciar equipe",
                    icon: Icons.medical_services,
                    onTap: () => Navigator.pushReplacementNamed(context, '/profissionais'),
                  ),
                  SummaryCard(
                    title: "Eventos",
                    description: "Criar e visualizar",
                    icon: Icons.event_outlined,
                    onTap: () => Navigator.pushReplacementNamed(context, '/eventos'),
                  ),
                  SummaryCard(
                    title: "Agenda",
                    description: "Controle de horários",
                    icon: Icons.calendar_today_outlined,
                    onTap: () => Navigator.pushReplacementNamed(context, '/agenda'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
