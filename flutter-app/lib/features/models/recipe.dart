import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String title,
    required int servingsBase,
    required List<String> tags,
    required List<String> satisfies,             // e.g., ["omnivore","vegetarian","vegan"]
    required List<String> excludesAllergens,     // e.g., ["nuts","shellfish"]
    required List<String> applianceRequirements, // ["stove","oven","grill"]
    required List<RecipeIngredient> ingredients,
    required List<String> steps,
    required int estPrepMin,
    required int estCookMin,
  }) = _Recipe;
  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}

@freezed
class RecipeIngredient with _$RecipeIngredient {
  const factory RecipeIngredient({
    required String itemName,   // canonical name (maps to Item later)
    required double qty,
    required String unit,       // "g"|"kg"|"ml"|"l"|"pcs"
    required String category,
  }) = _RecipeIngredient;
  factory RecipeIngredient.fromJson(Map<String, dynamic> json) => _$RecipeIngredientFromJson(json);
}
