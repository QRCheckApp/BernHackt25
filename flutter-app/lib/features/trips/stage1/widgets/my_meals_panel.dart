import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_state/providers.dart';
import '../../../models/recipe.dart';
import 'add_meal_dialog.dart';

class MyMealsPanel extends ConsumerStatefulWidget {
  final String tripId;
  final List<Recipe> userMeals;

  const MyMealsPanel({
    super.key,
    required this.tripId,
    required this.userMeals,
  });

  @override
  ConsumerState<MyMealsPanel> createState() => _MyMealsPanelState();
}

class _MyMealsPanelState extends ConsumerState<MyMealsPanel> {
  late List<Recipe> _localUserMeals;

  @override
  void initState() {
    super.initState();
    _localUserMeals = List.from(widget.userMeals);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Meine Mahlzeiten',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _showAddMealDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Neue Mahlzeit'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            if (_localUserMeals.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Noch keine Mahlzeiten',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Füge deine ersten Mahlzeiten hinzu',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._localUserMeals.map((meal) => _buildMealTile(meal)),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTile(Recipe meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.restaurant,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          meal.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                ...meal.tags.take(2).map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: 10,
                  ),
                )),
                if (meal.satisfies.isNotEmpty)
                  Chip(
                    label: Text(meal.satisfies.first),
                    backgroundColor: Colors.green.withValues(alpha: 0.1),
                    labelStyle: const TextStyle(color: Colors.green, fontSize: 10),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${meal.servingsBase} Portionen',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.timer,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${meal.estPrepMin + meal.estCookMin} min',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: FilledButton(
          onPressed: () => _addMealToTrip(meal),
          child: const Text('Zum Trip'),
        ),
      ),
    );
  }

  void _showAddMealDialog(BuildContext context) async {
    final result = await showDialog<Recipe>(
      context: context,
      builder: (context) => const AddMealDialog(),
    );

    if (result != null) {
      setState(() {
        _localUserMeals.add(result);
      });
      
      // Automatically like the newly added meal
      final currentUserId = ref.read(currentUserIdProvider);
      ref.read(tripVotesControllerProvider.notifier).addVote(
        tripId: widget.tripId,
        recipeId: result.id,
        memberId: currentUserId,
        vote: 1, // Like
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result.title} hinzugefügt und geliked'),
        ),
      );
    }
  }

  void _addMealToTrip(Recipe meal) {
    // Add the meal to the trip and automatically like it
    final currentUserId = ref.read(currentUserIdProvider);
    ref.read(tripVotesControllerProvider.notifier).addVote(
      tripId: widget.tripId,
      recipeId: meal.id,
      memberId: currentUserId,
      vote: 1, // Like
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${meal.title} zum Trip hinzugefügt und geliked'),
      ),
    );
  }
}
