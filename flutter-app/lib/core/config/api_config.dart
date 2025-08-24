import 'api_keys.dart';

class ApiConfig {
  // API keys are imported from api_keys.dart to keep them separate from version control
  static const String geminiApiKey = ApiKeys.geminiApiKey;
  
  // You can add other API keys here as needed
  // static const String openaiApiKey = ApiKeys.openaiApiKey;
  
  static bool get isGeminiAvailable => geminiApiKey != 'YOUR_GEMINI_API_KEY';
}
