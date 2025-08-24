import 'dart:async';
import '../../models/recipe.dart';
import 'backend_recipe_service.dart';

class BackendRecipeGenerator {
  static Future<Recipe?> generateRecipeFromText(String input) async {
    try {
      // Add timeout of 15 seconds for backend API
      final backendRecipe = await BackendRecipeService.generateRecipeFromText(input)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              print('Backend API timeout after 15 seconds');
              return null;
            },
          );
      
      if (backendRecipe != null) {
        print('Generated recipe using Backend API');
        return backendRecipe;
      }
    } catch (e) {
      print('Backend API failed: $e');
    }
    
    return null;
  }
}
