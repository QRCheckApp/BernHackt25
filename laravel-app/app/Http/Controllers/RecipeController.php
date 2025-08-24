<?php

namespace App\Http\Controllers;

use App\Models\Recipe;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;

class RecipeController extends Controller
{
    public function generate(Request $request)
    {
        $validated = $request->validate([
            'prompt' => 'required|string',
        ]);

        $prompt = $validated['prompt'];

        $apiKey = config('services.gemini.key');
        $url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key='.$apiKey;

        $instruction = 'Du bist ein erfahrener Koch und Rezeptgenerator. Erstelle ein detailliertes Rezept basierend auf der Benutzereingabe: "'.$prompt.'".'.
            ' Gib das Ergebnis ausschließlich als gültiges JSON mit den Feldern id, title, servingsBase, tags, satisfies,'.
            ' excludesAllergens, applianceRequirements, ingredients (itemName, qty, unit, category), steps, estPrepMin, estCookMin zurück.';

        $response = Http::post($url, [
            'contents' => [
                ['parts' => [['text' => $instruction]]],
            ],
        ]);

        if (! $response->successful()) {
            return response()->json(['error' => 'Unable to contact Gemini'], 500);
        }

        $text = data_get($response->json(), 'candidates.0.content.parts.0.text');
        $text = is_string($text) ? trim($text) : '';

        // Gemini sometimes wraps JSON in Markdown code fences; extract the JSON if present
        if (preg_match('/```json\s*(\{.*\})\s*```/s', $text, $matches)) {
            $text = $matches[1];
        }

        // Some Gemini responses incorrectly encode "excludesAllergens" as
        // `["Glutenfrei" : false, ...]` which is invalid JSON. Try to
        // convert that bracketed list into a JSON object so it can be parsed
        // and later normalised.
        $text = preg_replace_callback(
            '/"excludesAllergens"\s*:\s*\[(.*?)\]/s',
            static fn ($m) => '"excludesAllergens": {'.$m[1].'}',
            $text
        );

        // Other responses wrap a simple list like {"Milch","Eier"} in
        // curly braces instead of square brackets. Convert that to a proper
        // JSON array so it can be decoded.
        $text = preg_replace_callback(
            '/"excludesAllergens"\s*:\s*{([^}]*)}/s',
            static function ($m) {
                // If a colon is present, it already contains key/value pairs.
                if (str_contains($m[1], ':')) {
                    return $m[0];
                }

                $items = array_filter(array_map('trim', explode(',', $m[1])));
                $items = array_map(fn ($s) => trim($s, "'\""), $items);

                return '"excludesAllergens": ['
                    .implode(', ', array_map('json_encode', $items))
                    .']';
            },
            $text
        );

        $data = json_decode($text, true);

        if (! is_array($data)) {
            return response()->json(['error' => 'Invalid response from Gemini'], 500);
        }

        // Normalise excludesAllergens: if Gemini returned an associative array
        // with boolean values, keep only the keys that are truthy.
        if (isset($data['excludesAllergens']) && is_array($data['excludesAllergens']) && ! array_is_list($data['excludesAllergens'])) {
            $data['excludesAllergens'] = array_keys(array_filter($data['excludesAllergens']));
        }

        $recipe = Recipe::create([
            'slug' => Str::uuid()->toString(),
            'title' => $data['title'] ?? '',
            'servings_base' => $data['servingsBase'] ?? 0,
            'tags' => $data['tags'] ?? [],
            'satisfies' => $data['satisfies'] ?? [],
            'excludes_allergens' => $data['excludesAllergens'] ?? [],
            'appliance_requirements' => $data['applianceRequirements'] ?? [],
            'steps' => $data['steps'] ?? [],
            'est_prep_min' => $data['estPrepMin'] ?? null,
            'est_cook_min' => $data['estCookMin'] ?? null,
        ]);

        try {
            foreach ($data['ingredients'] ?? [] as $ingredient) {
                $recipe->ingredients()->create([
                    'item_name' => $ingredient['itemName'] ?? '',
                    'qty' => $ingredient['qty'] ?? 0,
                    'unit' => $ingredient['unit'] ?? null,
                    'category' => $ingredient['category'] ?? null,
                ]);
            }
        } catch (\Throwable $th) {
        }

        return response()->json([
            'id' => $recipe->slug,
            'title' => $recipe->title,
            'servingsBase' => $recipe->servings_base,
            'tags' => $recipe->tags,
            'satisfies' => $recipe->satisfies,
            'excludesAllergens' => $recipe->excludes_allergens,
            'applianceRequirements' => $recipe->appliance_requirements,
            'ingredients' => $recipe->ingredients()->get(['item_name as itemName', 'qty', 'unit', 'category'])->toArray(),
            'steps' => $recipe->steps,
            'estPrepMin' => $recipe->est_prep_min,
            'estCookMin' => $recipe->est_cook_min,
        ]);
    }
}
