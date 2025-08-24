<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

class RecipeGenerationTest extends TestCase
{
    use RefreshDatabase;

    public function test_it_generates_a_recipe_via_gemini(): void
    {
        if (! config('services.gemini.key')) {
            $this->markTestSkipped('GEMINI_API_KEY is not configured.');
        }

        $response = $this->postJson('/api/recipes/generate', [
            'prompt' => 'Schneckennudeln mit Tomaten',
        ]);

        $response->assertStatus(200)
            ->assertJsonStructure([
                'id', 'title', 'servingsBase', 'ingredients', 'steps',
            ]);
    }

    public function test_it_parses_markdown_wrapped_json_from_gemini(): void
    {
        Http::fake([
            'generativelanguage.googleapis.com/*' => Http::response([
                'candidates' => [[
                    'content' => [
                        'parts' => [[
                            'text' => "```json\n{".
                                '"title":"H\u00e4hnchen Curry",'.
                                '"servingsBase":4,'.
                                '"tags":[],"satisfies":[],"excludesAllergens":[],'.
                                '"applianceRequirements":[],'.
                                '"ingredients":[{"itemName":"H\u00e4hnchenbrust","qty":600,"unit":"g","category":"meat"}],'.
                                '"steps":["H\u00e4hnchen in St\u00fccke schneiden"],'.
                                '"estPrepMin":15,'.
                                '"estCookMin":25'.
                            "}\n```",
                        ]],
                    ],
                ]],
            ]),
        ]);

        $response = $this->postJson('/api/recipes/generate', [
            'prompt' => 'H\u00e4hnchen Curry',
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'title' => 'Hähnchen Curry',
            ]);
    }

    public function test_it_parses_curly_braced_excludes_allergens(): void
    {
        Http::fake([
            'generativelanguage.googleapis.com/*' => Http::response([
                'candidates' => [[
                    'content' => [
                        'parts' => [[
                            'text' => '{'
                                .'"title":"Test",'
                                .'"servingsBase":4,'
                                .'"tags":[],"satisfies":[],'
                                .'"excludesAllergens":{"Milch","Laktose"},'
                                .'"applianceRequirements":[],'
                                .'"ingredients":[],'
                                .'"steps":[],'
                                .'"estPrepMin":10,'
                                .'"estCookMin":20'
                                .'}',
                        ]],
                    ],
                ]],
            ]),
        ]);

        $response = $this->postJson('/api/recipes/generate', [
            'prompt' => 'Test',
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'excludesAllergens' => ['Milch', 'Laktose'],
            ]);
    }
}
