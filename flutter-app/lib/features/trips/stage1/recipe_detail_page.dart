import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app_state/providers.dart';
import '../../models/recipe.dart';

class RecipeDetailPage extends ConsumerWidget {
  final Recipe recipe;
  final String tripId;
  final bool showVotingButtons;

  const RecipeDetailPage({
    super.key,
    required this.recipe,
    required this.tripId,
    this.showVotingButtons = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final swipes = ref.watch(tripSwipesProvider(tripId));
    final myVote = swipes
        .where((s) => s.memberId == currentUserId && s.recipeId == recipe.id)
        .firstOrNull?.vote;
    
    // Get all votes for this recipe
    final recipeSwipes = swipes.where((s) => s.recipeId == recipe.id).toList();
    final likes = recipeSwipes.where((s) => s.vote > 0).length;
    final dislikes = recipeSwipes.where((s) => s.vote < 0).length;
    final superlikes = recipeSwipes.where((s) => s.vote == 3).length;
    final vetoes = recipeSwipes.where((s) => s.vote == -3).length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Recipe Image
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
                foregroundColor: Colors.white,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Vote indicators overlay
                    Positioned(
                      top: 100,
                      right: 20,
                      child: Column(
                        children: [
                          if (superlikes > 0)
                            _buildVoteIndicator(
                              Icons.favorite,
                              superlikes,
                              Colors.purple,
                            ),
                          const SizedBox(height: 8),
                          if (likes > 0)
                            _buildVoteIndicator(
                              Icons.thumb_up,
                              likes,
                              Colors.green,
                            ),
                          const SizedBox(height: 8),
                          if (dislikes > 0)
                            _buildVoteIndicator(
                              Icons.thumb_down,
                              dislikes,
                              Colors.red,
                            ),
                          const SizedBox(height: 8),
                          if (vetoes > 0)
                            _buildVoteIndicator(
                              Icons.block,
                              vetoes,
                              Colors.black,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Title and Author
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 18,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _findAuthorNameForRecipe(ref),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Quick Stats
                    _buildQuickStats(context),
                    const SizedBox(height: 32),

                    // Tags and Dietary Info
                    if (recipe.tags.isNotEmpty || recipe.satisfies.isNotEmpty) ...[
                      _buildTagsSection(context),
                      const SizedBox(height: 32),
                    ],

                    // Ingredients
                    _buildIngredientsSection(context),
                    const SizedBox(height: 32),

                    // Steps
                    _buildStepsSection(context),
                    const SizedBox(height: 32),

                    // Appliances & Allergens
                    _buildAdditionalInfo(context),
                    SizedBox(height: showVotingButtons ? 100 : 32), // Space for FAB if needed
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
      // Floating voting buttons (only show if showVotingButtons is true)
      floatingActionButton: showVotingButtons ? _buildVotingButtons(context, ref, myVote) : null,
      floatingActionButtonLocation: showVotingButtons ? FloatingActionButtonLocation.centerFloat : null,
    );
  }

  Widget _buildVoteIndicator(IconData icon, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final totalTime = recipe.estPrepMin + recipe.estCookMin;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            Icons.people_outline,
            'Portionen',
            '${recipe.servingsBase}',
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          _buildStatItem(
            context,
            Icons.schedule_outlined,
            'Gesamt',
            '${totalTime} min',
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          _buildStatItem(
            context,
            Icons.timer_outlined,
            'Vorbereitung',
            '${recipe.estPrepMin} min',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategorien & Ernährung',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...recipe.tags.map((tag) => _buildModernChip(
              context,
              tag,
              Icons.local_offer_outlined,
              Theme.of(context).colorScheme.tertiaryContainer,
            )),
            ...recipe.satisfies.map((diet) => _buildModernChip(
              context,
              diet,
              Icons.eco_outlined,
              Theme.of(context).colorScheme.secondaryContainer,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildModernChip(BuildContext context, String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            size: 16,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Zutaten',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...recipe.ingredients.asMap().entries.map((entry) {
          final index = entry.key;
          final ingredient = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ingredient.itemName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${ingredient.qty} ${ingredient.unit}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ingredient.category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStepsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.list_alt_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Zubereitung',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...recipe.steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                      ),
                    ),
                    child: Text(
                      step,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Zusätzliche Informationen',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                context,
                'Geräte',
                Icons.kitchen_outlined,
                recipe.applianceRequirements,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                context,
                'Allergene',
                Icons.warning_amber_outlined,
                recipe.excludesAllergens,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, IconData icon, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Text(
              'Keine Angaben',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 6,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildVotingButtons(BuildContext context, WidgetRef ref, int? currentVote) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildVoteButton(
            context,
            ref,
            Icons.block,
            Colors.black,
            -3,
            currentVote == -3,
            'Veto',
          ),
          _buildVoteButton(
            context,
            ref,
            Icons.thumb_down,
            Colors.red,
            -1,
            currentVote == -1,
            'Dislike',
          ),
          _buildVoteButton(
            context,
            ref,
            Icons.clear,
            Theme.of(context).colorScheme.outline,
            null,
            currentVote == null,
            'Neutral',
          ),
          _buildVoteButton(
            context,
            ref,
            Icons.thumb_up,
            Colors.green,
            1,
            currentVote == 1,
            'Like',
          ),
          _buildVoteButton(
            context,
            ref,
            Icons.favorite,
            Colors.purple,
            3,
            currentVote == 3,
            'Superlike',
          ),
        ],
      ),
    );
  }

  Widget _buildVoteButton(
    BuildContext context,
    WidgetRef ref,
    IconData icon,
    Color color,
    int? vote,
    bool isSelected,
    String tooltip,
  ) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () => _handleVoteChange(context, ref, vote),
        child: Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : color,
            size: 24,
          ),
        ),
      ),
    );
  }

  void _handleVoteChange(BuildContext context, WidgetRef ref, int? newVote) {
    final currentUserId = ref.read(currentUserIdProvider);
    
    if (newVote == null) {
      // Remove vote - not implemented in current provider, would need enhancement
      // For now, we can set vote to 0
      newVote = 0;
    }

    // Check superlike limit for new superlikes
    if (newVote == 3) {
      final swipes = ref.read(tripSwipesProvider(tripId));
      final currentRecipeVote = swipes
          .where((s) => s.memberId == currentUserId && s.recipeId == recipe.id)
          .firstOrNull?.vote;
      
      // Only check limit if this recipe doesn't already have a superlike from this user
      if (currentRecipeVote != 3) {
        final usedSuperlikes = swipes
            .where((swipe) => swipe.memberId == currentUserId && swipe.vote == 3)
            .length;
        if (usedSuperlikes >= 2) {
          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                content: Text('Du hast bereits alle deine Super-Likes verwendet'),
              ),
          );
          return;
        }
      }
    }

    ref.read(tripVotesControllerProvider.notifier).addVote(
      tripId: tripId,
      recipeId: recipe.id,
      memberId: currentUserId,
      vote: newVote,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bewertung geändert'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  String _findAuthorNameForRecipe(WidgetRef ref) {
    final trip = ref.read(tripDetailsProvider(tripId));
    if (trip == null) return 'Unbekannt';
    
    try {
      for (final member in trip.members) {
        final userMeals = ref.read(userMealsProvider(member.memberId));
        if (userMeals.any((meal) => meal.id == recipe.id)) {
          return member.name;
        }
      }
    } catch (e) {
      // Fallback if there's any issue
    }
    return 'Unbekannt';
  }
}
