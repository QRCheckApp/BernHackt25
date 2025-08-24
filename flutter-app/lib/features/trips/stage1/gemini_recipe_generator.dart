import 'dart:async';
import '../../models/recipe.dart';
import 'gemini_recipe_service.dart';

class GeminiRecipeGenerator {
  static bool _geminiInitialized = false;
  
  static void initializeGemini() {
    if (!_geminiInitialized) {
      try {
        GeminiRecipeService.initialize();
        _geminiInitialized = true;
      } catch (e) {
        print('Failed to initialize Gemini: $e');
      }
    }
  }
  
  static Future<Recipe?> generateRecipeFromText(String input) async {
    if (!_geminiInitialized) {
      print('Gemini not initialized');
      return null;
    }
    
    try {
      // Add timeout of 5 seconds for Gemini
      final geminiRecipe = await GeminiRecipeService.generateRecipeFromText(input)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              print('Gemini timeout after 15 seconds');
              return null;
            },
          );
      
      if (geminiRecipe != null) {
        print('Generated recipe using Gemini AI');
        return geminiRecipe;
      }
    } catch (e) {
      print('Gemini failed: $e');
    }
    
    return null;
  }
}
