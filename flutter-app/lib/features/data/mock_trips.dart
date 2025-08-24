import '../models/trip.dart';
import '../models/group.dart';
import '../models/recipe.dart';
import '../models/swipe.dart';
import 'seed_recipes.dart';

// Current user and admin status
const String currentUserId = "u_admin";
const bool isAdmin = true;

// Mock members with different diets and allergies
final List<MemberProfile> mockMembers = [
  MemberProfile(
    memberId: "u_admin",
    name: "Admin User",
    diet: "omnivore",
    allergies: ["nüsse"],
    dislikes: ["pilze"],
  ),
  MemberProfile(
    memberId: "u_2",
    name: "Anna Schmidt",
    diet: "vegetarian",
    allergies: ["laktose"],
    dislikes: ["fisch"],
  ),
  MemberProfile(
    memberId: "u_3",
    name: "Bob Müller",
    diet: "vegan",
    allergies: ["gluten", "soja"],
    dislikes: ["fleisch"],
  ),
  MemberProfile(
    memberId: "u_4",
    name: "Clara Weber",
    diet: "pescetarian",
    allergies: ["meeresfrüchte"],
    dislikes: ["scharf"],
  ),
  MemberProfile(
    memberId: "u_5",
    name: "David Fischer",
    diet: "omnivore",
    allergies: ["eier"],
    dislikes: ["koriander"],
  ),
  MemberProfile(
    memberId: "u_6",
    name: "Eva Wagner",
    diet: "vegetarian",
    allergies: ["nüsse", "sesam"],
    dislikes: ["oliven"],
  ),
];

// Mock trip summaries
final List<TripSummary> mockTrips = [
  TripSummary(
    id: "ski_davos",
    name: "Ski Hütte Davos",
    destination: "Davos, Switzerland",
    startDate: DateTime(2026, 2, 15),
    endDate: DateTime(2026, 2, 22),
    memberIds: ["u_admin", "u_2", "u_3", "u_4", "u_5", "u_6"],
    stage: TripStage.stage1,
    imagePath: "assets/images/davos.jpeg",
  ),
  TripSummary(
    id: "sommer_lago",
    name: "Sommerhaus Lago",
    destination: "Lago Maggiore, Italy",
    startDate: DateTime(2026, 7, 10),
    endDate: DateTime(2026, 7, 17),
    memberIds: ["u_admin", "u_2", "u_3", "u_4"],
    stage: TripStage.stage2,
    imagePath: "assets/images/lago.jpg",
  ),
];

// Mock trip details
final Map<String, Trip> mockTripDetails = {
  "ski_davos": Trip(
    id: "ski_davos",
    name: "Ski Hütte Davos",
    destination: "Davos, Switzerland",
    startDate: DateTime(2026, 2, 15),
    endDate: DateTime(2026, 2, 22),
    members: mockMembers,
    stage: TripStage.stage1,
    plannedMeals: [], // Initially empty, will be populated via Stage1 actions
    imagePath: "assets/images/davos.jpeg",
  ),
  "sommer_lago": Trip(
    id: "sommer_lago",
    name: "Sommerhaus Lago",
    destination: "Lago Maggiore, Italy",
    startDate: DateTime(2026, 7, 10),
    endDate: DateTime(2026, 7, 17),
    members: mockMembers.take(4).toList(), // Only first 4 members
    stage: TripStage.stage2,
    plannedMeals: ["","","","","",""],
    imagePath: "assets/images/lago.jpg",
  ),
};

// Mock user meals by user - simplified with just one recipe per user
final Map<String, List<Recipe>> mockUserMealsByUser = {
  "u_admin": [seedRecipes[0]], // pasta_carbonara
  "u_2": [seedRecipes[1]], // vegetarian_pasta
  "u_3": [seedRecipes[2]], // vegan_bowl
  "u_4": [], // no recipes
  "u_5": [seedRecipes[0]], // pasta_carbonara
  "u_6": [seedRecipes[1]], // vegetarian_pasta
};

// Mock swipes by trip - simplified with realistic voting patterns
final Map<String, List<Swipe>> mockSwipesByTrip = {
  "ski_davos": [
    Swipe(
      recipeId: "pasta_carbonara",
      memberId: "u_admin",
      vote: 1,
      ts: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Swipe(
      recipeId: "pasta_carbonara",
      memberId: "u_2",
      vote: 0, // vegetarian user dislikes meat dish
      ts: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Swipe(
      recipeId: "vegan_bowl",
      memberId: "u_3",
      vote: 1,
      ts: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Swipe(
      recipeId: "vegan_bowl",
      memberId: "u_4",
      vote: 1,
      ts: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ],
  "sommer_lago": [
    Swipe(
      recipeId: "vegetarian_pasta",
      memberId: "u_admin",
      vote: 1,
      ts: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Swipe(
      recipeId: "vegan_bowl",
      memberId: "u_2",
      vote: 1,
      ts: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
  ],
};


