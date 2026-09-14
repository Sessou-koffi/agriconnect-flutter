import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/activite_provider.dart';
import '../providers/culture_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/empty_state.dart';

class ActivitesScreen extends StatefulWidget {
  const ActivitesScreen({super.key});

  @override
  State<ActivitesScreen> createState() => _ActivitesScreenState();
}

class _ActivitesScreenState extends State<ActivitesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActiviteProvider>().loadActivites();
    });
  }

  Future<void> _deleteActivity(
    BuildContext context,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer l’activité ?'),
          content: const Text(
            'Cette activité sera définitivement supprimée.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await context.read<ActiviteProvider>().deleteActivite(id);
  }

  @override
  Widget build(BuildContext context) {
    final cultures = context.watch<CultureProvider>().cultures;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activités'),
      ),
      body: Consumer<ActiviteProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(provider.error!),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: provider.loadActivites,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (provider.activites.isEmpty) {
            return const EmptyState(
              icon: Icons.event_note_outlined,
              title: 'Aucune activité',
              message:
                  'Ajoutez une activité pour suivre les travaux réalisés.',
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadActivites,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.activites.length,
              separatorBuilder: (_,_) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final activite = provider.activites[index];

                return ActivityCard(
                  activite: activite,
                  onDelete: () => _deleteActivity(
                    context,
                    activite.id,
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: cultures.isEmpty
            ? null
            : () {
                context.push('/activites/new');
              },
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }
}