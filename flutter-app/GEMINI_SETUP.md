# Gemini AI Integration Setup

Diese App verwendet Google Gemini AI für intelligente Rezeptgenerierung. Hier ist die Anleitung zur Einrichtung:

## 🚀 Schnellstart

### 1. Gemini API Key erhalten

1. Gehe zu [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Melde dich mit deinem Google Account an
3. Klicke auf "Create API Key"
4. Kopiere den API Key

### 2. API Key in der App konfigurieren

1. **Kopiere die Template-Datei:**
   ```bash
   cp lib/core/config/api_keys_template.dart lib/core/config/api_keys.dart
   ```

2. **Öffne die Datei `lib/core/config/api_keys.dart` und ersetze:**
   ```dart
   static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
   ```

   mit deinem tatsächlichen API Key:

   ```dart
   static const String geminiApiKey = 'AIzaSyC...'; // Dein echter API Key
   ```

   ⚠️ **Wichtig**: Die Datei `api_keys.dart` wird automatisch von Git ignoriert, um deine API Keys zu schützen!

### 3. App neu starten

```bash
flutter run
```

## 🎯 Wie es funktioniert

### Hybrid AI System

Die App verwendet ein hybrides System:

1. **Gemini AI (Primär)**: Wenn verfügbar, generiert Gemini intelligente Rezepte
2. **Lokale AI (Fallback)**: Falls Gemini nicht verfügbar ist, wird die lokale KI verwendet

### Beispiel-Eingaben

- `"schnelle pasta mit tomatensauce"` → Generiert ein italienisches Pasta-Rezept
- `"vegetarisches curry"` → Erstellt ein vegetarisches Curry-Rezept
- `"gesunder salat"` → Macht einen frischen Salat
- `"vegane suppe"` → Kocht eine vegane Suppe

### Features

✅ **Intelligente Texterkennung** - Versteht verschiedene Schreibweisen
✅ **Kontextuelle Zutaten** - Generiert passende Zutaten
✅ **Realistische Schritte** - Erstellt logische Kochschritte
✅ **Angepasste Zeiten** - Berechnet realistische Zeiten
✅ **Ernährungspräferenzen** - Berücksichtigt vegetarisch/vegan
✅ **Automatisches Fallback** - Funktioniert auch ohne Internet

## 🔧 Konfiguration

### API Key Sicherheit

⚠️ **Wichtig**: Füge niemals API Keys direkt in den Code ein!

Für Produktionsumgebungen:
1. Verwende Umgebungsvariablen
2. Nutze sichere Key-Management-Systeme
3. Implementiere Rate Limiting

### Kosten

- Gemini API ist kostenlos für die ersten 15 Anfragen pro Minute
- Danach fallen geringe Kosten an (ca. $0.0005 pro Anfrage)
- Die lokale KI ist komplett kostenlos

## 🐛 Troubleshooting

### "API Key not configured"
- Stelle sicher, dass du die Datei `api_keys.dart` erstellt hast
- Überprüfe, dass der API Key in `api_keys.dart` eingetragen ist
- Überprüfe, dass der Key korrekt kopiert wurde

### "Gemini failed, falling back to local AI"
- Das ist normal! Die App verwendet automatisch die lokale KI
- Überprüfe deine Internetverbindung
- Stelle sicher, dass der API Key gültig ist

### Langsame Antworten
- Gemini benötigt 1-3 Sekunden für eine Antwort
- Die lokale KI ist sofort verfügbar

## 📱 Verwendung

1. Gehe zu Stage 1 in der App
2. Tippe deine Rezeptbeschreibung ein
3. Klicke auf den KI-Button (✨)
4. Warte auf die Generierung
5. Das Rezept wird automatisch hinzugefügt und geliked

## 🎨 Anpassung

Du kannst die KI-Prompts in `gemini_recipe_service.dart` anpassen:

```dart
static String _buildPrompt(String userInput) {
  // Hier kannst du den Prompt für Gemini anpassen
}
```

## 📞 Support

Bei Problemen:
1. Überprüfe die Konsole für Fehlermeldungen
2. Stelle sicher, dass alle Dependencies installiert sind
3. Teste mit der lokalen KI (ohne API Key)
