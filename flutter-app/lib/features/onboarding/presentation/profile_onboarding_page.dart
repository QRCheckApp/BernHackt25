import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../application/profile_onboarding_controller.dart';
import 'widgets/progress_rail.dart';
import 'widgets/welcome_step.dart';
import 'widgets/diet_step.dart';
import 'widgets/preferences_step.dart';
import 'widgets/review_step.dart';

class ProfileOnboardingPage extends ConsumerWidget {
  const ProfileOnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileOnboardingControllerProvider);
    final controller = ref.read(profileOnboardingControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil erstellen'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;
          
          if (isWide) {
            // Wide layout: Row with vertical ProgressRail on left
            return Row(
              children: [
                // Left sidebar with ProgressRail
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: ProgressRail(
                    currentStep: state.stepIndex,
                    vertical: true,
                    onStepTap: controller.goTo,
                  ),
                ),
                // Right content area
                Expanded(
                  child: _buildStepContent(context, state, controller),
                ),
              ],
            );
          } else {
            // Narrow layout: Column with horizontal ProgressRail on top
            return Column(
              children: [
                // Top ProgressRail
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: ProgressRail(
                    currentStep: state.stepIndex,
                    vertical: false,
                    onStepTap: controller.goTo,
                  ),
                ),
                // Content area
                Expanded(
                  child: _buildStepContent(context, state, controller),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, OnboardingState state, ProfileOnboardingController controller) {
    return Column(
      children: [
        // Step content
        Expanded(
          child: _buildStepBody(state.stepIndex, controller),
        ),
        // Footer buttons
        _buildFooterButtons(context, state, controller),
      ],
    );
  }

  Widget _buildStepBody(int stepIndex, ProfileOnboardingController controller) {
    switch (stepIndex) {
      case 0:
        return const WelcomeStep(key: ValueKey('welcome'));
      case 1:
        return DietStep(key: const ValueKey('diet'), controller: controller);
      case 2:
        return PreferencesStep(key: const ValueKey('preferences'), controller: controller);
      case 3:
        return ReviewStep(key: const ValueKey('review'), controller: controller);
      default:
        return const Center(child: Text('Unbekannter Schritt'));
    }
  }

  Widget _buildFooterButtons(BuildContext context, OnboardingState state, ProfileOnboardingController controller) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          if (state.stepIndex > 0)
            TextButton.icon(
              onPressed: () => controller.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Zurück'),
            )
          else
            const SizedBox.shrink(),
          
          // Next/Finish button
          ElevatedButton.icon(
            onPressed: () {
              if (state.stepIndex < 3) {
                controller.next();
                              } else {
                  // Finalize the profile
                  final success = controller.finalize();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profil erstellt')),
                    );
                    // Redirect to trips overview
                    context.go('/trips');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fehler beim Erstellen des Profils'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
            },
            icon: Icon(state.stepIndex < 3 ? Icons.arrow_forward : Icons.check),
            label: Text(state.stepIndex < 3 ? 'Weiter' : 'Abschließen'),
          ),
        ],
      ),
    );
  }
}
