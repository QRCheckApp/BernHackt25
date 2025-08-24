import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group.dart';
import '../models/kitchen_profile.dart';
import '../models/recipe.dart';
import '../models/swipe.dart';
import '../models/trip.dart';
import '../data/seed_recipes.dart';
import '../data/mock_trips.dart';
import 'swipe_storage_service.dart';
import 'app_state.dart';

// Demo group with 6 members
const _demoGroup = Group(
  id: 'demo_group',
  name: 'Demo Gruppe',
  days: 7,
  members: [
    MemberProfile(
      memberId: 'member1',
      name: 'Anna',
      diet: 'omnivore',
    ),
    MemberProfile(
      memberId: 'member2',
      name: 'Bob',
      diet: 'vegetarian',
    ),
    MemberProfile(
      memberId: 'member3',
      name: 'Clara',
      diet: 'vegan',
    ),
    MemberProfile(
      memberId: 'member4',
      name: 'David',
      diet: 'omnivore',
    ),
    MemberProfile(
      memberId: 'member5',
      name: 'Eva',
      diet: 'pescetarian',
    ),
    MemberProfile(
      memberId: 'member6',
      name: 'Frank',
      diet: 'vegetarian',
    ),
  ],
);

class AppStateNotifier extends StateNotifier<AppState> {
  final SwipeStorageService _storageService = SwipeStorageService();
  
  AppStateNotifier() : super(AppState(
    groups: [_demoGroup],
    currentGroupId: 'demo_group',
    candidates: seedRecipes,
    swipes: [],
  )) {
    _loadSwipes();
  }
  
  Future<void> _loadSwipes() async {
    final swipes = await _storageService.loadSwipes();
    state = state.copyWith(swipes: swipes);
  }

  void updateGroup(Group newGroup) {
    state = state.updateGroup(newGroup);
  }

  void updateMemberProfile(String memberId, MemberProfile updatedProfile) {
    state = state.copyWith(
      groups: [
        for (final g in state.groups)
          g.id == state.currentGroupId
            ? g.copyWith(
                members: [
                  for (final m in g.members)
                    if (m.memberId == memberId) updatedProfile else m
                ],
              )
            : g
      ]
    );
  }

  void setKitchenProfile(KitchenProfile profile) {
    state = state.setKitchenProfile(profile);
  }

  void setOnboardingComplete(bool complete) {
    state = state.setOnboardingComplete(complete);
  }

  Future<void> addSwipe(Swipe swipe) async {
    final newState = state.addSwipe(swipe);
    state = newState;
    await _storageService.saveSwipes(newState.swipes);
  }

  Future<void> updateSwipe(String recipeId, String memberId, int newVote) async {
    final newState = state.updateSwipe(recipeId, memberId, newVote);
    state = newState;
    await _storageService.saveSwipes(newState.swipes);
  }
  
  Future<void> clearAllSwipes() async {
    try {
      await _storageService.clearSwipes();
      state = state.copyWith(swipes: []);
      // Add a small delay to ensure state propagation
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      // If storage clearing fails, still update the state
      state = state.copyWith(swipes: []);
      await Future.delayed(const Duration(milliseconds: 100));
      rethrow;
    }
  }

  void addRecipe(Recipe recipe) {
    state = state.addRecipe(recipe);
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

// Helper providers
final currentGroupProvider = Provider<Group>((ref) {
  return ref.watch(appStateProvider).currentGroup;
});

final candidatesProvider = Provider<List<Recipe>>((ref) {
  return ref.watch(appStateProvider).candidates;
});

final swipesProvider = Provider<List<Swipe>>((ref) {
  return ref.watch(appStateProvider).swipes;
});



final kitchenProfileProvider = Provider<KitchenProfile?>((ref) {
  return ref.watch(appStateProvider).kitchenProfile;
});

final onboardingCompleteProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).onboardingComplete;
});

// Trip-related providers
final currentUserIdProvider = Provider<String>((ref) {
  return currentUserId;
});

final isAdminProvider = Provider<bool>((ref) {
  return isAdmin;
});

final tripsProvider = Provider<List<TripSummary>>((ref) {
  return mockTrips;
});

final tripDetailsProvider = Provider.family<Trip?, String>((ref, tripId) {
  return mockTripDetails[tripId];
});

final userMealsProvider = Provider.family<List<Recipe>, String>((ref, userId) {
  return mockUserMealsByUser[userId] ?? [];
});

// TripVotesController for managing trip-specific votes
class TripVotesController extends StateNotifier<Map<String, List<Swipe>>> {
  TripVotesController() : super({
    for (final trip in mockTripDetails.entries)
      trip.key: mockSwipesByTrip[trip.key] ?? []
  });

  void addVote({
    required String tripId,
    required String recipeId,
    required String memberId,
    required int vote,
  }) {
    final currentSwipes = state[tripId] ?? [];
    
    // Remove any existing vote from this member for this recipe
    final filteredSwipes = currentSwipes
        .where((s) => !(s.memberId == memberId && s.recipeId == recipeId))
        .toList();
    
    // Add new vote (only if vote is not 0/neutral)
    final updatedSwipes = [...filteredSwipes];
    if (vote != 0) {
      final swipe = Swipe(
        recipeId: recipeId,
        memberId: memberId,
        vote: vote,
        ts: DateTime.now(),
      );
      updatedSwipes.add(swipe);
    }
    
    state = {...state, tripId: updatedSwipes};
  }
}

final tripVotesControllerProvider = StateNotifierProvider<TripVotesController, Map<String, List<Swipe>>>((ref) {
  return TripVotesController();
});

// Updated tripSwipesProvider to read from TripVotesController
final tripSwipesProvider = Provider.family<List<Swipe>, String>((ref, tripId) {
  final votesState = ref.watch(tripVotesControllerProvider);
  return votesState[tripId] ?? [];
});



final tripStageProvider = Provider.family<TripStage?, String>((ref, tripId) {
  final trip = mockTripDetails[tripId];
  return trip?.stage;
});

final tripAllMealsProvider = Provider.family<List<Recipe>, String>((ref, tripId) {
  // we assume: tripDetailsProvider, userMealsProvider, and mock_trips.dart expose the members on the trip.
  final trip = ref.watch(tripDetailsProvider(tripId));
  // aggregate each member's meals (mocked) and remove duplicates
  final meals = <Recipe>[];
  final seenRecipeIds = <String>{};
  
  if (trip != null) {
    for (final m in trip.members) {
      final userMeals = ref.watch(userMealsProvider(m.memberId));
      for (final meal in userMeals) {
        if (!seenRecipeIds.contains(meal.id)) {
          seenRecipeIds.add(meal.id);
          meals.add(meal);
        }
      }
    }
  }
  return meals;
});

// Selectors for vote counts
final likesCountForTripProvider = Provider.family<int, String>((ref, tripId) {
  final swipes = ref.watch(tripSwipesProvider(tripId));
  return swipes.where((swipe) => swipe.vote > 0).length;
});

final dislikesCountForTripProvider = Provider.family<int, String>((ref, tripId) {
  final swipes = ref.watch(tripSwipesProvider(tripId));
  return swipes.where((swipe) => swipe.vote < 0).length;
});

final recipeScoreInTripProvider = Provider.family<int, (String, String)>((ref, params) {
  final tripId = params.$1;
  final recipeId = params.$2;
  final swipes = ref.watch(tripSwipesProvider(tripId));
  return swipes
      .where((swipe) => swipe.recipeId == recipeId)
      .fold(0, (sum, swipe) => sum + swipe.vote);
});

// TripStageController
class TripStageController extends StateNotifier<Map<String, TripStage>> {
  TripStageController() : super({
    for (final trip in mockTripDetails.entries)
      trip.key: trip.value.stage
  });

  void endStage1(String tripId) {
    if (state[tripId] == TripStage.stage1) {
      state = {...state, tripId: TripStage.stage2};
    }
  }
}

final tripStageControllerProvider = StateNotifierProvider<TripStageController, Map<String, TripStage>>((ref) {
  return TripStageController();
});


