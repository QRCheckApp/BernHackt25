import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';

import 'add_recipe_page.dart';
import 'recipe_detail_page.dart';
import 'gemini_recipe_generator.dart';
import '../../app_state/providers.dart';
import '../../models/recipe.dart';

class Stage1View extends ConsumerStatefulWidget {
  final String tripId;
  const Stage1View({super.key, required this.tripId});

  @override
  ConsumerState<Stage1View> createState() => _Stage1ViewState();
}

class _Stage1ViewState extends ConsumerState<Stage1View> {
  final TextEditingController _quickGenCtrl = TextEditingController();
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    // Initialize Gemini AI
    GeminiRecipeGenerator.initializeGemini();
  }

  @override
  void dispose() {
    _quickGenCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripId = widget.tripId;
    final currentUserId = ref.watch(currentUserIdProvider);
    final trip = ref.watch(tripDetailsProvider(tripId));
    final allMeals = ref.watch(tripAllMealsProvider(tripId));

    final swipes = ref.watch(tripSwipesProvider(tripId));
    final mySwipes = swipes.where((s) => s.memberId == currentUserId).toList();

    final totalLikes = swipes.where((s) => s.vote > 0).length;
    final totalDislikes = swipes.where((s) => s.vote < 0).length;
    final myLikes = mySwipes.where((s) => s.vote > 0).length;
    final myDislikes = mySwipes.where((s) => s.vote < 0).length;

    // Get unswiped recipes for the current user
    final swipedRecipeIds = mySwipes.map((s) => s.recipeId).toSet();
    final unswipedRecipes = allMeals.where((r) => !swipedRecipeIds.contains(r.id)).toList();

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: _buildOverviewView(context, allMeals, swipes, mySwipes, totalLikes, totalDislikes, myLikes, myDislikes),
          ),
        ),

        // FLOATING INPUT: text field + plus button to generate a recipe (mock)
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: Row(
                children: [
                  Expanded(
                    child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: TextField(
                      controller: _quickGenCtrl,
                      decoration: const InputDecoration(
                        hintText: 'z. B. „schnelle Pasta mit Tomatensauce" oder „vegetarisches Curry"',
                        border: InputBorder.none,
                      ),
                    ),
            ),
          ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () async {
                      setState(() => _isGenerating = true);
                      await Future.delayed(const Duration(seconds: 1));
                      
                      final txt = _quickGenCtrl.text.trim();
                      if (txt.isEmpty) {
                        setState(() => _isGenerating = false);
                        return;
                      }
                      
                      try {
                        // Use Gemini AI to generate recipe
                        final Recipe? generatedRecipe = await GeminiRecipeGenerator.generateRecipeFromText(txt);
                        
                        if (generatedRecipe != null) {
                          // Gemini succeeded
                          setState(() {
                            _quickGenCtrl.clear();
                          });
                          
                          // Add recipe to dynamic recipes controller
                          ref.read(dynamicRecipesControllerProvider.notifier).addRecipe(
                            widget.tripId,
                            generatedRecipe,
                          );
                          
                          // Automatically like the generated recipe
                          final currentUserId = ref.read(currentUserIdProvider);
                          ref.read(tripVotesControllerProvider.notifier).addVote(
                            tripId: widget.tripId,
                            recipeId: generatedRecipe.id,
                            memberId: currentUserId,
                            vote: 1, // Like
                          );
                        } else {
                          // Gemini failed - show error message
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('KI-Service nicht verfügbar. Bitte versuche es später erneut.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        print('Error generating recipe: $e');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Fehler beim Generieren des Rezepts: $e'),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ),
                          );
                        }
                      } finally {
                        setState(() => _isGenerating = false);
                      }
                    },
                    icon: _isGenerating ? const CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(Colors.white),) : const Icon(Icons.auto_awesome),
                    tooltip: 'KI-Rezept generieren',
                  ),
                ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewView(BuildContext context, List<Recipe> allMeals, List<dynamic> swipes, List<dynamic> mySwipes, int totalLikes, int totalDislikes, int myLikes, int myDislikes) {
    // Calculate unswiped count dynamically
    final swipedRecipeIds = mySwipes.map((s) => s.recipeId).toSet();
    final unswipedRecipes = allMeals.where((r) => !swipedRecipeIds.contains(r.id)).toList();
    final unswipedCount = unswipedRecipes.length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      children: [
        
        
        

        // 2) PRIMARY BUTTON: navigate to swipe page
        FilledButton.icon(
          onPressed: unswipedCount > 0 ? () {
            context.push('/trips/${widget.tripId}/swipe');
          } : null,
          icon: const Icon(Icons.swipe),
          label: Text(unswipedCount > 0 ? 'Jetzt swipen ($unswipedCount übrig)' : 'Alle bewertet!'),
        ),

        const SizedBox(height: 16),

        // 3) LIST OF ALL MEALS (with "by whom")
        Row(
          children: [
            Icon(
              Icons.list_alt,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text('Alle Mahlzeiten', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 8),
        ...allMeals.mapIndexed((i, r) {
          final author = _findAuthorNameForRecipe(r);
          final myVote = mySwipes.firstWhereOrNull((s) => s.recipeId == r.id)?.vote;
          final totalTime = r.estPrepMin + r.estCookMin;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                // Navigate to recipe detail page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailPage(
                      recipe: r,
                      tripId: widget.tripId,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                clipBehavior: Clip.antiAlias,
                child: Container(
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
                                  r.title,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Author with icon
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      size: 16,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      author != null ? author : 'Unbekannt',
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
                                      text: r.satisfies.isNotEmpty ? r.satisfies.first : 'mixed',
                                      icon: Icons.eco_outlined,
                                      color: Theme.of(context).colorScheme.secondaryContainer,
                                    ),
                                    _ModernTag(
                                      text: '${totalTime} min',
                                      icon: Icons.schedule_outlined,
                                      color: Theme.of(context).colorScheme.tertiaryContainer,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Right side: vote indicator and chevron
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (myVote != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: myVote > 0 
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    myVote > 0 ? Icons.thumb_up : Icons.thumb_down,
                                    color: myVote > 0 ? Colors.green : Colors.red,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
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
            ),
          );
        }),

        const SizedBox(height: 8),

        // 4) GREY "Add manually" button at bottom (opens new page)
        TextButton(
          onPressed: () async {
            final res = await Navigator.of(context).push<Map<String, dynamic>>(
              MaterialPageRoute(builder: (_) => const AddRecipePage()),
            );
            if (res != null) {
              // Build a mocked Recipe and append to local list
              final rnd = Random().nextInt(99999);
              final Recipe mock = Recipe(
                id: 'manual_$rnd',
                title: res['title'] as String,
                servingsBase: (res['servings'] as int?) ?? 4,
                tags: const ['manuell'],
                satisfies: const ['omnivore'],
                excludesAllergens: const [],
                applianceRequirements: const ['herd'],
                ingredients: [
                  RecipeIngredient(
                    itemName: (res['ingredient'] as Map)['name'] as String,
                    qty: ((res['ingredient'] as Map)['qty'] as num).toDouble(),
                    unit: ((res['ingredient'] as Map)['unit'] as String),
                    category: 'misc',
                  ),
                ],
                steps: const ['Alles zusammenrühren (Mock)'],
                estPrepMin: 5,
                estCookMin: 10,
              );
              
              // Add recipe to dynamic recipes controller
              ref.read(dynamicRecipesControllerProvider.notifier).addRecipe(
                widget.tripId,
                mock,
              );
              
              // Automatically like the recipe that was just added
              final currentUserId = ref.read(currentUserIdProvider);
              ref.read(tripVotesControllerProvider.notifier).addVote(
                tripId: widget.tripId,
                recipeId: mock.id,
                memberId: currentUserId,
                vote: 1, // Like
              );
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rezept hinzugefügt und geliked (Mock)')),
              );
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          child: const Text('Manuell hinzufügen'),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  String? _findAuthorNameForRecipe(Recipe r) {
    // Find which user has this recipe in their meal list
    final trip = ref.read(tripDetailsProvider(widget.tripId));
    if (trip == null) return null;
    
    try {
      // Check if it's a dynamically added recipe (from Gemini AI or manual addition)
      final dynamicRecipes = ref.read(dynamicRecipesControllerProvider)[widget.tripId] ?? [];
      if (dynamicRecipes.any((recipe) => recipe.id == r.id)) {
        return 'Du'; // User who added it
      }
      
      // Check if it's from a user's meal list
      for (final member in trip.members) {
        final userMeals = ref.read(userMealsProvider(member.memberId));
        if (userMeals.any((meal) => meal.id == r.id)) {
          return member.name;
        }
      }
    } catch (e) {
      // Fallback if there's any issue
    }
    return null;
  }

  String _titleFromText(String txt) {
    // simple prettify
    final s = txt.trim();
    if (s.isEmpty) return 'Neues Rezept';
    return s[0].toUpperCase() + s.substring(1);
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              value,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall,
      ),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isSmall;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: isSmall ? 20 : 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
