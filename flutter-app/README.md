# huette

Eine Flutter-App zur Verwaltung von Reisen, Rezepten und Einkaufslisten.

## 🔑 API-Schlüssel Einrichtung

Dieses Projekt verwendet die Gemini AI API zur Rezeptgenerierung. So richtest du deinen API-Schlüssel ein:

1. **Hole dir deinen API-Schlüssel** von [Google AI Studio](https://makersuite.google.com/app/apikey)
2. **Kopiere die Vorlagendatei:**
   ```bash
   cp lib/core/config/api_keys_template.dart lib/core/config/api_keys.dart
   ```
3. **Füge deinen API-Schlüssel** in `lib/core/config/api_keys.dart` hinzu
4. **Die API-Schlüssel-Datei wird automatisch von Git ignoriert**, um deine Schlüssel sicher zu halten

Für detaillierte Einrichtungsanweisungen siehe [GEMINI_SETUP.md](GEMINI_SETUP.md).
