import '../models/group.dart';
import '../models/kitchen_profile.dart';
import '../models/recipe.dart';
import '../models/swipe.dart';

class AppState {
  final List<Group> groups;
  final String currentGroupId;
  final KitchenProfile? kitchenProfile;
  final List<Recipe> candidates;
  final List<Swipe> swipes;
  final bool onboardingComplete;

  const AppState({
    required this.groups,
    required this.currentGroupId,
    this.kitchenProfile,
    required this.candidates,
    required this.swipes,
    this.onboardingComplete = false,
  });

  Group get currentGroup {
    return groups.firstWhere((g) => g.id == currentGroupId);
  }

  AppState copyWith({
    List<Group>? groups,
    String? currentGroupId,
    KitchenProfile? kitchenProfile,
    List<Recipe>? candidates,
    List<Swipe>? swipes,
    bool? onboardingComplete,
  }) {
    return AppState(
      groups: groups ?? this.groups,
      currentGroupId: currentGroupId ?? this.currentGroupId,
      kitchenProfile: kitchenProfile ?? this.kitchenProfile,
      candidates: candidates ?? this.candidates,
      swipes: swipes ?? this.swipes,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  AppState updateGroup(Group newGroup) {
    final updatedGroups = groups.map((g) => g.id == currentGroupId ? newGroup : g).toList();
    return copyWith(groups: updatedGroups);
  }

  AppState updateMemberProfile(String memberId, MemberProfile updatedProfile) {
    final updatedGroups = groups.map((g) {
      if (g.id == currentGroupId) {
        final updatedMembers = g.members.map((member) {
          if (member.memberId == memberId) {
            return updatedProfile;
          }
          return member;
        }).toList();
        return g.copyWith(members: updatedMembers);
      }
      return g;
    }).toList();
    
    return copyWith(groups: updatedGroups);
  }

  AppState setKitchenProfile(KitchenProfile profile) {
    return copyWith(kitchenProfile: profile);
  }

  AppState setOnboardingComplete(bool complete) {
    return copyWith(onboardingComplete: complete);
  }

  AppState addSwipe(Swipe swipe) {
    final updatedSwipes = [...swipes, swipe];
    return copyWith(swipes: updatedSwipes);
  }

  AppState updateSwipe(String recipeId, String memberId, int newVote) {
    final updatedSwipes = swipes.map((swipe) {
      if (swipe.recipeId == recipeId && swipe.memberId == memberId) {
        return swipe.copyWith(
          vote: newVote,
          ts: DateTime.now(),
        );
      }
      return swipe;
    }).toList();
    return copyWith(swipes: updatedSwipes);
  }

  AppState addRecipe(Recipe recipe) {
    final updatedCandidates = [...candidates, recipe];
    return copyWith(candidates: updatedCandidates);
  }
}
