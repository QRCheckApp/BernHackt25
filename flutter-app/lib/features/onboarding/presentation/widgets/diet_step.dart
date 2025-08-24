import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/profile_onboarding_controller.dart';
import 'onboarding_data.dart';

class DietStep extends ConsumerWidget {
  final ProfileOnboardingController controller;

  const DietStep({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileOnboardingControllerProvider);
    final profile = state.tempProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // Header
          Text(
            'Ernährungspräferenzen',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Erzähle uns von deiner Ernährung und Allergien',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Diet Selection
          Text(
            'Ernährungstyp',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DietType.values.map((diet) {
              final isSelected = profile.diet == diet.name;
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(diet.emoji),
                    const SizedBox(width: 8),
                    Text(diet.displayName),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    controller.updateDiet(diet.name);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          
          // Other diet type
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
          const SizedBox(height: 32),

          // Allergies
          Text(
            'Allergien',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Wähle alle Lebensmittel aus, auf die du allergisch bist',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AllergyType.values.map((allergy) {
              final isSelected = profile.allergies.contains(allergy.name);
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(allergy.emoji),
                    const SizedBox(width: 8),
                    Text(allergy.displayName),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  controller.toggleAllergy(allergy.name);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          
          // Other allergies
          TextField(
            decoration: const InputDecoration(
              hintText: 'Andere Allergien (durch Kommas getrennt)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                final otherAllergies = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                // Add other allergies to the existing ones
                for (final allergy in otherAllergies) {
                  if (!profile.allergies.contains(allergy)) {
                    controller.toggleAllergy(allergy);
                  }
                }
              }
            },
          ),
          const SizedBox(height: 32),

          // Dislikes
          Text(
            'Abneigungen',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gib Lebensmittel ein, die du nicht magst (durch Kommas getrennt)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            decoration: const InputDecoration(
              hintText: 'z.B. Pilze, Oliven, Koriander',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              controller.setDislikes(value);
            },
            controller: TextEditingController(
              text: profile.dislikes.join(', '),
            ),
          ),
          const SizedBox(height: 32),

          // Info card
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Du kannst diese Präferenzen jederzeit in deinen Profileinstellungen aktualisieren.',
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
