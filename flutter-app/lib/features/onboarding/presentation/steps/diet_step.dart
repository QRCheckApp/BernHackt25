import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/profile_onboarding_controller.dart';


class DietStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const DietStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileOnboardingControllerProvider);
    final profile = state.tempProfile;
    final controller = ref.read(profileOnboardingControllerProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          
          // Header
          Text(
            'Ernährung & Allergien',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Diet Selection Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ernährungstyp',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'omnivore',
                      'vegetarian',
                      'vegan',
                      'pescetarian',
                    ].map((diet) {
                      final isSelected = profile.diet == diet;
                      return FilterChip(
                        label: Text(_getDietDisplayName(diet)),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            controller.updateDiet(diet);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Andere Ernährungsweise (optional)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        controller.updateDiet(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Allergies Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Allergien',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'nüsse',
                      'laktose',
                      'gluten',
                      'meeresfrüchte',
                      'soja',
                      'eier',
                      'erdnüsse',
                    ].map((allergy) {
                      final isSelected = profile.allergies.contains(allergy);
                      return FilterChip(
                        label: Text(allergy),
                        selected: isSelected,
                        onSelected: (selected) {
                          controller.toggleAllergy(allergy);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Andere Allergien (durch Kommas getrennt)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final otherAllergies = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                        final allAllergies = [...profile.allergies, ...otherAllergies];
                        controller.setAllergies(allAllergies);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Preferences Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Präferenzen',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Kein Alkohol'),
                    subtitle: const Text('Rezepte mit Alkohol ausschließen'),
                    value: !profile.alcoholOk,
                    onChanged: (value) {
                      controller.setAlcoholOk(!value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Kein Koffein'),
                    subtitle: const Text('Rezepte mit Koffein ausschließen'),
                    value: !profile.caffeineOk,
                    onChanged: (value) {
                      controller.setCaffeineOk(!value);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Nicht gemochte Lebensmittel (z.B. Pilze, Oliven)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.setDislikes(value);
                    },
                    controller: TextEditingController(
                      text: profile.dislikes.join(', '),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Footer buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
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
                  onPressed: onNext,
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _getDietDisplayName(String diet) {
    switch (diet) {
      case 'omnivore':
        return 'Alles';
      case 'vegetarian':
        return 'Vegetarisch';
      case 'vegan':
        return 'Vegan';
      case 'pescetarian':
        return 'Pescetarisch';
      default:
        return diet;
    }
  }
}
