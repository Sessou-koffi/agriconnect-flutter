import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/culture_provider.dart';
//import '../models/culture.dart';

class CultureDetailScreen extends StatelessWidget {
  const CultureDetailScreen({
    super.key,
    required this.cultureId,
  });

  final String cultureId;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final culture = context.read<CultureProvider>().getCultureById(
          cultureId,
        );

    if (culture == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Culture'),
        ),
        body: const Center(
          child: Text('Culture introuvable.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(culture.nom),
        actions: [
          IconButton(
            onPressed: () async {
              await context.push(
                '/cultures/${culture.id}/edit',
                extra: culture,
              );

              if (!context.mounted) {
                return;
              }

              context.read<CultureProvider>().loadCultures();
            },
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Modifier',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    child: Icon(
                      Icons.eco,
                      size: 44,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    culture.nom,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(culture.type),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _InfoTile(
            icon: Icons.grid_view_outlined,
            title: 'Parcelle',
            value: culture.parcelle,
          ),
          _InfoTile(
            icon: Icons.calendar_today_outlined,
            title: 'Date de plantation',
            value: _formatDate(culture.datePlantation),
          ),
          _InfoTile(
            icon: Icons.event_available_outlined,
            title: 'Récolte prévue',
            value: _formatDate(culture.dateRecoltePrevue),
          ),
          _InfoTile(
            icon: Icons.flag_outlined,
            title: 'Statut',
            value: culture.statut,
          ),
          const SizedBox(height: 16),
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            culture.description.isEmpty
                ? 'Aucune description.'
                : culture.description,
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
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
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}