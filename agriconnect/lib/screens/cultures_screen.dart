import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/culture_provider.dart';
import '../widgets/culture_card.dart';
import '../widgets/empty_state.dart';


class CulturesScreen extends StatefulWidget {
  const CulturesScreen({super.key});

  @override
  State<CulturesScreen> createState() => _CulturesScreenState();
}

class _CulturesScreenState extends State<CulturesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CultureProvider>().loadCultures();
    });
  }

  Future<void> _deleteCulture(
    BuildContext context,
    String cultureId,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer la culture ?'),
          content: const Text(
            'Cette action supprimera définitivement cette culture.',
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

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    await context.read<CultureProvider>().deleteCulture(cultureId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes cultures'),
      ),
      body: Consumer<CultureProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: provider.loadCultures,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.cultures.isEmpty) {
            return const EmptyState(
              icon: Icons.agriculture_outlined,
              title: 'Aucune culture enregistrée',
              message:
                  'Ajoutez votre première culture pour commencer votre suivi agricole.',
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadCultures,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.cultures.length,
              separatorBuilder: (_,_) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final culture = provider.cultures[index];

                return CultureCard(
                  culture: culture,
                  onTap: () {
                    context.push('/cultures/${culture.id}');
                  },
                  onDelete: () => _deleteCulture(
                    context,
                    culture.id,
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/cultures/new');

          if (!context.mounted) {
            return;
          }

          await context.read<CultureProvider>().loadCultures();
        },
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }
}