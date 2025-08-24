import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/swipe.dart';

class SwipeStorageService {
  static const String _swipesKey = 'swipes';
  
  // Save swipes to SharedPreferences
  Future<void> saveSwipes(List<Swipe> swipes) async {
    final prefs = await SharedPreferences.getInstance();
    final swipesJson = swipes.map((swipe) => swipe.toJson()).toList();
    await prefs.setString(_swipesKey, jsonEncode(swipesJson));
  }
  
  // Load swipes from SharedPreferences
  Future<List<Swipe>> loadSwipes() async {
    final prefs = await SharedPreferences.getInstance();
    final swipesString = prefs.getString(_swipesKey);
    
    if (swipesString == null) {
      return [];
    }
    
    try {
      final List<dynamic> swipesJson = jsonDecode(swipesString);
      return swipesJson.map((json) => Swipe.fromJson(json)).toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }
  
  // Clear all swipes
  Future<void> clearSwipes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_swipesKey);
  }
}
