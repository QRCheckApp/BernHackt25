import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/group.dart';
import '../../app_state/providers.dart';
import '../../data/mock_trips.dart';

// Simple class to hold user intent data
class UserIntents {
  final String favoritesText;
  final List<String> cuisines;

  const UserIntents({
    this.favoritesText = '',
    this.cuisines = const [],
  });

  UserIntents copyWith({
    String? favoritesText,
    List<String>? cuisines,
  }) {
    return UserIntents(
      favoritesText: favoritesText ?? this.favoritesText,
      cuisines: cuisines ?? this.cuisines,
    );
  }
}

// Immutable state class for onboarding
class OnboardingState {
  final int stepIndex;
  final MemberProfile tempProfile;
  final UserIntents intents;

  const OnboardingState({
    required this.stepIndex,
    required this.tempProfile,
    required this.intents,
  });

  OnboardingState copyWith({
    int? stepIndex,
    MemberProfile? tempProfile,
    UserIntents? intents,
  }) {
    return OnboardingState(
      stepIndex: stepIndex ?? this.stepIndex,
      tempProfile: tempProfile ?? this.tempProfile,
      intents: intents ?? this.intents,
    );
  }
}

// Riverpod Notifier for Profile Onboarding
class ProfileOnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    // Initialize with default values
    return OnboardingState(
      stepIndex: 0,
      tempProfile: MemberProfile(
        memberId: currentUserId,
        name: 'Guest',
        diet: 'omnivore',
      ),
      intents: const UserIntents(),
    );
  }

  void next() {
    if (state.stepIndex < 5) { // Assuming 6 steps (0-5)
      state = state.copyWith(stepIndex: state.stepIndex + 1);
    }
  }

  void back() {
    if (state.stepIndex > 0) {
      state = state.copyWith(stepIndex: state.stepIndex - 1);
    }
  }

  void goTo(int step) {
    if (step >= 0 && step <= 5) { // Assuming 6 steps (0-5)
      state = state.copyWith(stepIndex: step);
    }
  }

  void updateDiet(String diet) {
    state = state.copyWith(
      tempProfile: state.tempProfile.copyWith(diet: diet),
    );
  }

  void toggleAllergy(String allergy) {
    final currentAllergies = List<String>.from(state.tempProfile.allergies);
    if (currentAllergies.contains(allergy)) {
      currentAllergies.remove(allergy);
    } else {
      currentAllergies.add(allergy);
    }
    
    state = state.copyWith(
      tempProfile: state.tempProfile.copyWith(allergies: currentAllergies),
    );
  }

  void setAllergies(List<String> allergies) {
    state = state.copyWith(
      tempProfile: state.tempProfile.copyWith(allergies: allergies),
    );
  }

  void setDislikes(String csv) {
    final dislikes = csv.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    state = state.copyWith(
      tempProfile: state.tempProfile.copyWith(dislikes: dislikes),
    );
  }

  void setAlcoholOk(bool alcoholOk) {
    state = state.copyWith(
      tempProfile: state.tempProfile.copyWith(alcoholOk: alcoholOk),
    );
  }

  void setCaffeineOk(bool caffeineOk) {
    state = state.copyWith(
      tempProfile: state.tempProfile.copyWith(caffeineOk: caffeineOk),
    );
  }

  void updateIntents({
    String? favoritesText,
    List<String>? cuisines,
  }) {
    state = state.copyWith(
      intents: state.intents.copyWith(
        favoritesText: favoritesText,
        cuisines: cuisines,
      ),
    );
  }

  bool finalize() {
    try {
      // Call updateMemberProfile from app_state/providers.dart
      ref.read(appStateProvider.notifier).updateMemberProfile(
        currentUserId,
        state.tempProfile,
      );
      
      // Mark onboarding as complete
      ref.read(appStateProvider.notifier).setOnboardingComplete(true);
      
      return true;
    } catch (e) {
      return false;
    }
  }
}

// Expose provider
final profileOnboardingControllerProvider = NotifierProvider<ProfileOnboardingController, OnboardingState>(
  ProfileOnboardingController.new,
);
