import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/culture_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriConnect'),
      ),
      body: Consumer<CultureProvider>(
        builder: (context, provider, child) {
          final culturesCount = provider.cultures.length;

          return RefreshIndicator(
            onRefresh: provider.loadCultures,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Tableau de bord',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Suivez simplement vos activités agricoles.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),

                // Statistiques
                Row(
                  children: [
                    Expanded(
                      child: _DashboardCard(
                        icon: Icons.agriculture_outlined,
                        title: 'Cultures',
                        value: culturesCount.toString(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: _DashboardCard(
                        icon: Icons.task_alt_outlined,
                        title: 'Activités',
                        value: '0',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'Accès rapides',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.eco_outlined),
                    ),
                    title: const Text('Mes cultures'),
                    subtitle: const Text(
                      'Consulter et gérer vos cultures',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // La navigation sera ajoutée avec le routeur.
                    },
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.event_note_outlined),
                    ),
                    title: const Text('Activités'),
                    subtitle: const Text(
                      'Suivre les activités agricoles',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // La navigation sera ajoutée ensuite.
                    },
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.lightbulb_outline),
                    ),
                    title: const Text('Conseils'),
                    subtitle: const Text(
                      'Consulter les conseils agricoles',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // La navigation sera ajoutée ensuite.
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}