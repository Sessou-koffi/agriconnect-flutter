import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/conseil_provider.dart';
import '../widgets/conseil_card.dart';
import '../widgets/empty_state.dart';

class ConseilsScreen extends StatefulWidget {
  const ConseilsScreen({super.key});

  @override
  State<ConseilsScreen> createState() => _ConseilsScreenState();
}

class _ConseilsScreenState extends State<ConseilsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ConseilProvider>();

      if (provider.conseils.isEmpty) {
        provider.loadConseils();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conseils agricoles'),
      ),
      body: Consumer<ConseilProvider>(
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
                    onPressed: provider.loadConseils,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  onChanged: provider.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un conseil...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: provider.searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              provider.setSearchQuery('');
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 52,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = provider.categories[index];

                    return FilterChip(
                      label: Text(category),
                      selected: provider.selectedCategory == category,
                      onSelected: (_) {
                        provider.setCategory(category);
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: provider.filteredConseils.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off_outlined,
                        title: 'Aucun conseil trouvé',
                        message:
                            'Essayez une autre recherche ou une autre catégorie.',
                      )
                    : RefreshIndicator(
                        onRefresh: provider.loadConseils,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.filteredConseils.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final conseil =
                                provider.filteredConseils[index];

                            return ConseilCard(
                              conseil: conseil,
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}