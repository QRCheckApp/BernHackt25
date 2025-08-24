import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/profile_onboarding_controller.dart';

class ReviewStep extends ConsumerWidget {
  final VoidCallback onBack;
  final Future<void> Function() onFinish;

  const ReviewStep({
    super.key,
    required this.onBack,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileOnboardingControllerProvider);
    final profile = state.tempProfile;
    final intents = state.intents;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // Header
          Text(
            'Profil überprüfen',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Überprüfe deine Angaben vor dem Speichern',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Summary Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile section
                  _buildSectionHeader(context, 'Profil', Icons.person),
                  const SizedBox(height: 16),
                  
                  // Diet
                  _buildSummaryRow(context, 'Ernährung', _getDietDisplayName(profile.diet)),
                  
                  // Allergies
                  if (profile.allergies.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildSummaryRow(context, 'Allergien', ''),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: profile.allergies.map((allergy) {
                        return Chip(
                          label: Text(allergy),
                          backgroundColor: Theme.of(context).colorScheme.errorContainer,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  
                  // Alcohol & Caffeine
                  const SizedBox(height: 12),
                  _buildSummaryRow(context, 'Getränke', 'Alkohol: ${profile.alcoholOk ? "OK" : "Nicht OK"}, Koffein: ${profile.caffeineOk ? "OK" : "Nicht OK"}'),
                  
                  // Dislikes
                  if (profile.dislikes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildSummaryRow(context, 'Nicht gemocht', profile.dislikes.join(', ')),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Preferences section
                  _buildSectionHeader(context, 'Vorlieben', Icons.favorite),
                  const SizedBox(height: 16),
                  
                  // Favorites text
                  if (intents.favoritesText.isNotEmpty) ...[
                    _buildSummaryRow(context, 'Lieblingsgerichte', intents.favoritesText),
                    const SizedBox(height: 12),
                  ],
                  
                  // Cuisines
                  if (intents.cuisines.isNotEmpty) ...[
                    _buildSummaryRow(context, 'Lieblingsküchen', ''),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: intents.cuisines.map((cuisine) {
                        return Chip(
                          label: Text(cuisine),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                  

                ],
              ),
            ),
          ),
          
          const Spacer(),
          
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
                  onPressed: () async {
                    await onFinish();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Profil erstellen',
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

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  String _getDietDisplayName(String diet) {
    switch (diet) {
      case 'omnivore':
        return 'Alles (Omnivore)';
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
