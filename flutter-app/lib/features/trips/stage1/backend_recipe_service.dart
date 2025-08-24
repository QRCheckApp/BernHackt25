import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/recipe.dart';

class BackendRecipeService {
  static const String _baseUrl = 'https://backend.bernhackt25.qrcheck.app';
  static const String _generateEndpoint = '/api/recipes/generate';
  
  static Future<Recipe?> generateRecipeFromText(String input) async {
    try {
      final url = Uri.parse('$_baseUrl$_generateEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'input': input,
        }),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print('Backend API timeout after 15 seconds');
          throw Exception('Request timeout');
        },
      );
      
      if (response.statusCode == 200) {
        // Check if response is valid JSON
        try {
          final responseData = json.decode(response.body);
          return _parseBackendResponse(responseData, input);
        } catch (e) {
          // If response is not valid JSON (e.g., "Hello World :-)"), create a fallback recipe
          print('Backend returned non-JSON response: ${response.body}');
          return _createFallbackRecipe(input);
        }
      } else {
        print('Backend API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Backend API Error: $e');
      return null;
    }
  }
  
  static Recipe _parseBackendResponse(Map<String, dynamic> jsonData, String originalInput) {
    try {
      // Parse ingredients
      final ingredients = (jsonData['ingredients'] as List).map((ingredient) {
        return RecipeIngredient(
          itemName: ingredient['itemName'] as String,
          qty: (ingredient['qty'] as num).toDouble(),
          unit: ingredient['unit'] as String? ?? 'g', // Handle null units
          category: ingredient['category'] as String,
        );
      }).toList();
      
      // Create recipe
      return Recipe(
        id: 'backend_${DateTime.now().millisecondsSinceEpoch}',
        title: jsonData['title'] as String,
        servingsBase: jsonData['servingsBase'] as int,
        tags: List<String>.from(jsonData['tags']),
        satisfies: List<String>.from(jsonData['satisfies']),
        excludesAllergens: List<String>.from(jsonData['excludesAllergens']),
        applianceRequirements: List<String>.from(jsonData['applianceRequirements']),
        ingredients: ingredients,
        steps: List<String>.from(jsonData['steps']),
        estPrepMin: jsonData['estPrepMin'] as int,
        estCookMin: jsonData['estCookMin'] as int,
      );
    } catch (e) {
      print('Error parsing backend response: $e');
      print('Response was: $jsonData');
      throw Exception('Failed to parse backend response');
    }
  }
  
  static Recipe _createFallbackRecipe(String input) {
    // Create a smart fallback recipe based on user input
    final lowerInput = input.toLowerCase();
    
    // Determine recipe type based on input
    String title;
    List<String> tags;
    List<String> ingredients;
    List<String> steps;
    
    if (lowerInput.contains('pasta') || lowerInput.contains('nudeln')) {
      title = 'Einfache Pasta';
      tags = ['italienisch', 'schnell', 'einfach'];
      ingredients = ['Pasta', 'Olivenöl', 'Knoblauch', 'Salz'];
      steps = [
        'Wasser in einem großen Topf zum Kochen bringen',
        'Pasta nach Packungsanweisung kochen',
        'Knoblauch hacken und in Olivenöl anbraten',
        'Pasta abgießen und mit Knoblauchöl mischen',
        'Mit Salz abschmecken'
      ];
    } else if (lowerInput.contains('salat') || lowerInput.contains('salad')) {
      title = 'Frischer Salat';
      tags = ['gesund', 'frisch', 'vegetarisch'];
      ingredients = ['Salat', 'Tomaten', 'Gurke', 'Olivenöl'];
      steps = [
        'Salat waschen und trocknen',
        'Tomaten und Gurke schneiden',
        'Alles in einer Schüssel mischen',
        'Mit Olivenöl und Salz würzen'
      ];
    } else if (lowerInput.contains('curry') || lowerInput.contains('indisch')) {
      title = 'Einfaches Curry';
      tags = ['indisch', 'würzig', 'vegetarisch'];
      ingredients = ['Reis', 'Curry-Pulver', 'Kokosmilch', 'Gemüse'];
      steps = [
        'Reis nach Packungsanweisung kochen',
        'Gemüse schneiden und anbraten',
        'Curry-Pulver hinzufügen und kurz anrösten',
        'Kokosmilch hinzufügen und köcheln lassen',
        'Mit Reis servieren'
      ];
    } else {
      title = 'Rezept basierend auf: $input';
      tags = ['generiert', 'experimentell'];
      ingredients = ['Hauptzutat', 'Gewürze', 'Öl'];
      steps = [
        'Hauptzutat vorbereiten',
        'Gewürze hinzufügen',
        'Nach Geschmack würzen',
        'Servieren'
      ];
    }
    
    return Recipe(
      id: 'fallback_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      servingsBase: 4,
      tags: tags,
      satisfies: ['omnivore'],
      excludesAllergens: [],
      applianceRequirements: ['herd'],
      ingredients: ingredients.map((name) => RecipeIngredient(
        itemName: name,
        qty: 100.0,
        unit: 'g',
        category: 'produce',
      )).toList(),
      steps: steps,
      estPrepMin: 10,
      estCookMin: 15,
    );
  }
}
