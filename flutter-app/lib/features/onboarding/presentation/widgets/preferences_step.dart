import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/profile_onboarding_controller.dart';
import 'onboarding_data.dart';

class PreferencesStep extends ConsumerWidget {
  final ProfileOnboardingController controller;

  const PreferencesStep({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileOnboardingControllerProvider);
    final profile = state.tempProfile;
    final intents = state.intents;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // Header
          Text(
            'Lebensmittelvorlieben',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Erzähle uns von deinen Lieblingslebensmitteln und Vorlieben',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Favorite foods text
          Text(
            'Lieblingslebensmittel',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Beschreibe deine Lieblingslebensmittel oder Gerichte',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'z.B. Ich liebe Pastagerichte, scharfes Essen und frische Salate...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              controller.updateIntents(favoritesText: value);
            },
            controller: TextEditingController(text: intents.favoritesText),
          ),
          const SizedBox(height: 32),

          // Cuisines
          Text(
            'Lieblingsküchen',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Wähle deine Lieblingsküchen',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: CuisineType.values.map((cuisine) {
              final isSelected = intents.cuisines.contains(cuisine.name);
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cuisine.emoji),
                    const SizedBox(width: 8),
                    Text(cuisine.displayName),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  final newCuisines = List<String>.from(intents.cuisines);
                  if (selected) {
                    newCuisines.add(cuisine.name);
                  } else {
                    newCuisines.remove(cuisine.name);
                  }
                  controller.updateIntents(cuisines: newCuisines);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Other foods
          Text(
            'Andere Lebensmittel',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Füge andere Lebensmittel hinzu, die du magst',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            decoration: const InputDecoration(
              hintText: 'z.B. Avocado, Quinoa, Lachs (durch Kommas getrennt)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                final otherFoods = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                // Add to favorites text
                final currentFavorites = intents.favoritesText;
                final newFavorites = currentFavorites.isEmpty 
                    ? otherFoods.join(', ')
                    : '$currentFavorites, ${otherFoods.join(', ')}';
                controller.updateIntents(favoritesText: newFavorites);
              }
            },
          ),
          const SizedBox(height: 32),

          // Alcohol and Caffeine preferences
          Text(
            'Getränkevorlieben',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.local_bar,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  const Text('Alkohol OK'),
                ],
              ),
              subtitle: const Text('Rezepte mit Alkohol einschließen'),
              value: profile.alcoholOk,
              onChanged: (value) {
                controller.setAlcoholOk(value);
              },
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.coffee,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  const Text('Koffein OK'),
                ],
              ),
              subtitle: const Text('Rezepte mit Koffein einschließen'),
              value: profile.caffeineOk,
              onChanged: (value) {
                controller.setCaffeineOk(value);
              },
            ),
          ),
          const SizedBox(height: 24),

          // Info card
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Diese Informationen helfen uns dabei, Mahlzeiten zu empfehlen, die zu deinen Geschmacksvorlieben passen.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
