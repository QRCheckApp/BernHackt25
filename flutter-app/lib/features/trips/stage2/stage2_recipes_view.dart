import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../stage1/recipe_detail_page.dart';
import '../../app_state/providers.dart';
import '../../models/recipe.dart';
import '../../data/seed_recipes.dart';

class Stage2RecipesView extends ConsumerStatefulWidget {
  final String tripId;
  const Stage2RecipesView({super.key, required this.tripId});

  @override
  ConsumerState<Stage2RecipesView> createState() => _Stage2RecipesViewState();
}

class _Stage2RecipesViewState extends ConsumerState<Stage2RecipesView> {
  late List<Recipe> _allRecipes;

  @override
  void initState() {
    super.initState();
    // Combine seed recipes with any additional recipes for stage 2
    _allRecipes = [...seedRecipes];
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripDetailsProvider(widget.tripId));
    
    if (trip == null) {
      return const Center(
        child: Text('Trip nicht gefunden'),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: _buildRecipesList(context, _allRecipes),
      ),
    );
  }

  Widget _buildRecipesList(BuildContext context, List<Recipe> recipes) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      children: [
        // Header
        Row(
          children: [
            Icon(
              Icons.restaurant_menu,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Gewählte Rezepte (${recipes.length})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Alle für diesen Trip ausgewählten Rezepte. Tippe auf ein Rezept für Details.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),

        // Recipe cards
        ...recipes.mapIndexed((i, recipe) {
          final totalTime = recipe.estPrepMin + recipe.estCookMin;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                // Navigate to recipe detail page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailPage(
                      recipe: recipe,
                      tripId: widget.tripId,
                      showVotingButtons: false,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.surfaceContainerLowest,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Left side: recipe avatar
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.primaryContainer,
                                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.restaurant_menu,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Center: recipe info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Recipe name
                              Text(
                                recipe.title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Servings info
                              Row(
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${recipe.servingsBase} Portionen',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Tags
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  _ModernTag(
                                    text: recipe.satisfies.isNotEmpty ? recipe.satisfies.first : 'mixed',
                                    icon: Icons.eco_outlined,
                                    color: Theme.of(context).colorScheme.secondaryContainer,
                                  ),
                                  _ModernTag(
                                    text: '${totalTime} min',
                                    icon: Icons.schedule_outlined,
                                    color: Theme.of(context).colorScheme.tertiaryContainer,
                                  ),
                                  if (recipe.tags.isNotEmpty)
                                    _ModernTag(
                                      text: recipe.tags.first,
                                      icon: Icons.label_outline,
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Right side: chevron and status
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Status indicator (could be used for "completed" status later)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.check_circle_outline,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ModernTag extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  
  const _ModernTag({
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
