import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/profile_onboarding_controller.dart';

class PreferencesStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const PreferencesStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<PreferencesStep> createState() => _PreferencesStepState();
}

class _PreferencesStepState extends ConsumerState<PreferencesStep> {
  late TextEditingController _favoritesController;
  late TextEditingController _otherFoodsController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(profileOnboardingControllerProvider);
    _favoritesController = TextEditingController(text: state.intents.favoritesText);
    _otherFoodsController = TextEditingController();
  }

  @override
  void dispose() {
    _favoritesController.dispose();
    _otherFoodsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileOnboardingControllerProvider);
    final intents = state.intents;
    final controller = ref.read(profileOnboardingControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // Header
          Text(
            'Essensvorlieben',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Erzähle uns von deinen Lieblingsgerichten',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Favorites TextField with Speech Input
          Text(
            'Lieblingsgerichte & Vorlieben',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Beschreibe deine Lieblingsgerichte und Essensvorlieben',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _favoritesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'z.B. Ich liebe Pasta-Gerichte, scharfes Essen und frische Salate...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    controller.updateIntents(favoritesText: value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  // Mock speech-to-text functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Spracheingabe (Mock)')),
                  );
                  
                  // Append " (voice)" to the current text
                  final currentText = _favoritesController.text;
                  final newText = currentText.isEmpty ? ' (voice)' : '$currentText (voice)';
                  _favoritesController.text = newText;
                  controller.updateIntents(favoritesText: newText);
                },
                icon: const Icon(Icons.mic),
                label: const Text('Spracheingabe'),
              ),
            ],
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
            'Wähle deine bevorzugten Küchen aus',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'italienisch',
              'asiatisch',
              'mexikanisch',
              'indisch',
              'mediterran',
              'grill',
              'frühstück',
            ].map((cuisine) {
              final isSelected = intents.cuisines.contains(cuisine);
              return FilterChip(
                label: Text(cuisine),
                selected: isSelected,
                onSelected: (selected) {
                  final newCuisines = List<String>.from(intents.cuisines);
                  if (selected) {
                    newCuisines.add(cuisine);
                  } else {
                    newCuisines.remove(cuisine);
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
            'Weitere Lebensmittel, die du gerne isst',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _otherFoodsController,
            decoration: const InputDecoration(
              hintText: 'z.B. Avocado, Quinoa, Süßkartoffeln',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                final otherFoods = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                controller.updateIntents(favoritesText: otherFoods.join(', '));
              }
            },
          ),
          
          const Spacer(),
          
          // Footer buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Zurück',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Weiter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
