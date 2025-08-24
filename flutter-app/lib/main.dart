import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'features/trips/stage1/gemini_recipe_generator.dart';

void main() {
  // Initialize Gemini AI
  GeminiRecipeGenerator.initializeGemini();
  
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
