import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/profile_onboarding_controller.dart';
import 'onboarding_data.dart';

class ReviewStep extends ConsumerWidget {
  final ProfileOnboardingController controller;

  const ReviewStep({
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
            'Profil überprüfen',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bitte überprüfe deine Präferenzen vor dem Speichern',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Profile summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Profilübersicht',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Diet
                  _buildSummaryItem(
                    context,
                    'Ernährung',
                    _getDietDisplayNameWithEmoji(profile.diet),
                    Icons.restaurant,
                  ),
                  
                  // Allergies
                  if (profile.allergies.isNotEmpty)
                    _buildSummaryItem(
                      context,
                      'Allergien',
                      _getAllergiesDisplayWithEmojis(profile.allergies),
                      Icons.warning,
                    ),
                  
                  // Dislikes
                  if (profile.dislikes.isNotEmpty)
                    _buildSummaryItem(
                      context,
                      'Abneigungen',
                      profile.dislikes.join(', '),
                      Icons.thumb_down,
                    ),
                  
                  // Alcohol & Caffeine
                  _buildSummaryItem(
                    context,
                    'Getränke',
                    _getDrinksDisplayWithIcons(profile.alcoholOk, profile.caffeineOk),
                    Icons.local_bar,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Preferences summary card
          if (intents.favoritesText.isNotEmpty || intents.cuisines.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Lebensmittelvorlieben',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Favorite foods text
                    if (intents.favoritesText.isNotEmpty)
                      _buildSummaryItem(
                        context,
                        'Lieblingslebensmittel',
                        intents.favoritesText,
                        Icons.favorite_border,
                      ),
                    
                    // Cuisines
                    if (intents.cuisines.isNotEmpty)
                      _buildSummaryItem(
                        context,
                        'Lieblingsküchen',
                        _getCuisinesDisplayWithEmojis(intents.cuisines),
                        Icons.public,
                      ),
                    

                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),

          // Final info card
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Dein Profil wird gespeichert und du kannst mit Hütte beginnen, um personalisierte Mahlzeitenempfehlungen zu entdecken!',
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

  Widget _buildSummaryItem(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDietDisplayNameWithEmoji(String diet) {
    final dietType = DietType.fromString(diet);
    return '${dietType.emoji} ${dietType.displayName}';
  }

  String _getAllergiesDisplayWithEmojis(List<String> allergies) {
    return allergies.map((allergy) {
      final allergyType = AllergyType.fromString(allergy);
      if (allergyType != null) {
        return '${allergyType.emoji} ${allergyType.displayName}';
      }
      return allergy;
    }).join(', ');
  }

  String _getCuisinesDisplayWithEmojis(List<String> cuisines) {
    return cuisines.map((cuisine) {
      final cuisineType = CuisineType.fromString(cuisine);
      if (cuisineType != null) {
        return '${cuisineType.emoji} ${cuisineType.displayName}';
      }
      return cuisine;
    }).join(', ');
  }

  String _getDrinksDisplayWithIcons(bool alcoholOk, bool caffeineOk) {
    final alcoholIcon = alcoholOk ? '🍷' : '🚫';
    final caffeineIcon = caffeineOk ? '☕' : '🚫';
    return '$alcoholIcon Alkohol: ${alcoholOk ? "OK" : "Nicht OK"}, $caffeineIcon Koffein: ${caffeineOk ? "OK" : "Nicht OK"}';
  }


}
