import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_state/providers.dart';
import '../../../models/recipe.dart';
import 'swipe_deck_inline.dart';

class SwipePanelEntry extends ConsumerWidget {
  final String tripId;

  const SwipePanelEntry({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final allMeals = ref.watch(tripAllMealsProvider(tripId));
    final swipes = ref.watch(tripSwipesProvider(tripId));
    
    // Get unswiped recipes for the current user
    final mySwipes = swipes.where((s) => s.memberId == currentUserId).toList();
    final swipedRecipeIds = mySwipes.map((s) => s.recipeId).toSet();
    final unswipedRecipes = allMeals.where((r) => !swipedRecipeIds.contains(r.id)).toList();

    // Calculate statistics using new selectors
    final totalLikes = ref.watch(likesCountForTripProvider(tripId));
    final totalDislikes = ref.watch(dislikesCountForTripProvider(tripId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.swipe,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'MealSwipe',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Live summary chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SummaryChip(
                  label: 'Geplante Mahlzeiten',
                  value: allMeals.length.toString(),
                  icon: Icons.restaurant_menu,
                ),
                _SummaryChip(
                  label: 'Likes',
                  value: totalLikes.toString(),
                  icon: Icons.thumb_up,
                  color: Colors.green,
                ),
                _SummaryChip(
                  label: 'Dislikes',
                  value: totalDislikes.toString(),
                  icon: Icons.thumb_down,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Swipe deck
            SwipeDeckInline(
              recipes: unswipedRecipes,
              tripId: tripId,
              onSwipeComplete: () {
                // This will be called when all recipes are swiped
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Alle Rezepte bewertet!'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (color ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color ?? Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}
