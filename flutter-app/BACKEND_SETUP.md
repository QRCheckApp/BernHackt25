# Backend API Integration Setup

Diese App verwendet jetzt einen Backend-Server für intelligente Rezeptgenerierung anstelle von Google Gemini AI.

## 🚀 Backend API Endpoint

Die App sendet POST-Anfragen an:
```
https://backend.bernhackt25.qrcheck.app/api/recipes/generate
```

## 📡 API Request Format

Die App sendet folgende JSON-Daten:

```json
{
  "input": "Benutzereingabe für Rezeptgenerierung"
}
```

### Beispiel-Request:
```json
{
  "input": "schnelle pasta mit tomatensauce"
}
```

## 📥 API Response Format

Der Backend-Server sollte folgendes JSON-Format zurückgeben:

```json
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
```

## 🔧 Implementierung

### Neue Dateien:
- `lib/features/trips/stage1/backend_recipe_service.dart` - HTTP-Client für Backend API
- `lib/features/trips/stage1/backend_recipe_generator.dart` - Generator-Klasse

### Geänderte Dateien:
- `lib/features/trips/stage1/stage1_view.dart` - Verwendet Backend statt Gemini
- `lib/main.dart` - Entfernt Gemini-Initialisierung

## 🎯 Features

✅ **HTTP POST Requests** - Sendet Benutzereingaben an Backend
✅ **Timeout Handling** - 15 Sekunden Timeout für API-Calls
✅ **Error Handling** - Graceful Fallback bei Fehlern
✅ **JSON Parsing** - Automatische Konvertierung zu Recipe-Objekten
✅ **User Feedback** - Zeigt Status und Fehlermeldungen

## 🐛 Troubleshooting

### "Backend-Service nicht verfügbar"
- Überprüfe die Internetverbindung
- Stelle sicher, dass der Backend-Server läuft
- Überprüfe die API-Endpoint-URL

### "Request timeout"
- Der Backend-Server antwortet zu langsam
- Überprüfe die Server-Performance
- Erhöhe ggf. den Timeout-Wert

### "Backend returned non-JSON response"
- Der Backend-Server antwortet mit "Hello World :-)" anstatt JSON
- Die App erstellt automatisch ein Fallback-Rezept
- Das Backend muss noch vollständig implementiert werden

### "Failed to parse backend response"
- Das Backend gibt ein ungültiges JSON-Format zurück
- Überprüfe das Response-Format
- Stelle sicher, dass alle erforderlichen Felder vorhanden sind

## 📱 Verwendung

1. Gehe zu Stage 1 in der App
2. Tippe deine Rezeptbeschreibung ein
3. Klicke auf den Backend-Button (✨)
4. Die App sendet die Eingabe an den Backend-Server
5. Das generierte Rezept wird automatisch hinzugefügt und geliked

## 🔄 Migration von Gemini

Die Migration von Gemini zu Backend API:

1. **Entfernt**: Gemini API Key Konfiguration
2. **Ersetzt**: `GeminiRecipeGenerator` → `BackendRecipeGenerator`
3. **Hinzugefügt**: HTTP-Client für Backend-Kommunikation
4. **Beibehalten**: Gleiche Recipe-Modelle und UI

## 📞 Support

Bei Problemen:
1. Überprüfe die Konsole für Fehlermeldungen
2. Teste den Backend-Endpoint direkt
3. Überprüfe das Network-Tab im Browser
4. Stelle sicher, dass alle Dependencies installiert sind
