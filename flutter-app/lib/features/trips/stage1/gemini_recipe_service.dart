import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../models/recipe.dart';
import '../../../core/config/api_config.dart';

class GeminiRecipeService {
  static late final GenerativeModel _model;
  
  static void initialize() {
    if (!ApiConfig.isGeminiAvailable) {
      throw Exception('Gemini API key not configured');
    }
    
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: ApiConfig.geminiApiKey,
    );
  }
  
  static Future<Recipe?> generateRecipeFromText(String input) async {
    try {
      final prompt = _buildPrompt(input);
      final response = await _model.generateContent([Content.text(prompt)]);
      
      if (response.text != null) {
        return _parseGeminiResponse(response.text!, input);
      }
    } catch (e) {
      print('Gemini API Error: $e');
      // Fallback to local AI generator
      return null;
    }
    return null;
  }
  
  static String _buildPrompt(String userInput) {
    return '''
Du bist ein erfahrener Koch und Rezeptgenerator. Erstelle ein detailliertes Rezept basierend auf der Benutzereingabe: "$userInput"

Antworte NUR mit einem JSON-Objekt im folgenden Format:

{
  "title": "Rezepttitel",
  "servingsBase": 4,
  "tags": ["tag1", "tag2"],
  "satisfies": ["omnivore"],
  "excludesAllergens": [],
  "applianceRequirements": ["herd"],
  "ingredients": [
    {
      "itemName": "Zutat Name",
      "qty": 500.0,
      "unit": "g",
      "category": "kategorie"
    }
  ],
  "steps": [
    "Schritt 1",
    "Schritt 2"
  ],
  "estPrepMin": 15,
  "estCookMin": 30
}

Wichtige Regeln:
- Verwende realistische Mengen und Zeiten
- Füge passende Tags hinzu (z.B. "italienisch", "schnell", "vegetarisch")
- Erstelle logische Kochschritte
- Verwende deutsche Zutatennamen
- Berücksichtige Ernährungspräferenzen aus der Eingabe
- Mach das Rezept für 4 Personen
- Verwende nur die angegebenen Kategorien: pasta, produce, dairy, meat, grains, spices, oil, canned, beverage, sweetener
- Verwende IMMER gültige Einheiten: "g", "kg", "ml", "l", "pcs", "Stück", "Bund", "Dose"
- Verwende NIE null oder leere Werte für Einheiten

Beispiel für "schnelle pasta mit tomatensauce":
{
  "title": "Schnelle Pasta mit Tomatensauce",
  "servingsBase": 4,
  "tags": ["italienisch", "schnell", "einfach"],
  "satisfies": ["omnivore"],
  "excludesAllergens": [],
  "applianceRequirements": ["herd"],
  "ingredients": [
    {"itemName": "Pasta", "qty": 400.0, "unit": "g", "category": "pasta"},
    {"itemName": "Tomaten", "qty": 500.0, "unit": "g", "category": "produce"},
    {"itemName": "Olivenöl", "qty": 30.0, "unit": "ml", "category": "oil"},
    {"itemName": "Salz", "qty": 5.0, "unit": "g", "category": "spices"},
    {"itemName": "Pfeffer", "qty": 3.0, "unit": "g", "category": "spices"}
  ],
  "steps": [
    "Wasser in einem großen Topf zum Kochen bringen",
    "Pasta nach Packungsanweisung kochen",
    "Tomaten schneiden und in einer Pfanne anbraten",
    "Pasta abgießen und mit den Tomaten mischen",
    "Mit Salz und Pfeffer abschmecken"
  ],
  "estPrepMin": 10,
  "estCookMin": 15
}
''';
  }
  
  static Recipe _parseGeminiResponse(String response, String originalInput) {
    try {
      // Clean up the response to extract JSON
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      
      if (jsonStart == -1 || jsonEnd == 0) {
        throw Exception('No JSON found in response');
      }
      
      final jsonString = response.substring(jsonStart, jsonEnd);
      final jsonData = json.decode(jsonString);
      
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
        id: 'gemini_${DateTime.now().millisecondsSinceEpoch}',
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
      print('Error parsing Gemini response: $e');
      print('Response was: $response');
      throw Exception('Failed to parse Gemini response');
    }
  }
}
