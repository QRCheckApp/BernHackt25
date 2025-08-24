<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Recipe extends Model
{
    protected $fillable = [
        'slug',
        'title',
        'servings_base',
        'tags',
        'satisfies',
        'excludes_allergens',
        'appliance_requirements',
        'steps',
        'est_prep_min',
        'est_cook_min',
    ];

    protected $casts = [
        'tags' => 'array',
        'satisfies' => 'array',
        'excludes_allergens' => 'array',
        'appliance_requirements' => 'array',
        'steps' => 'array',
    ];

    public function ingredients(): HasMany
    {
        return $this->hasMany(RecipeIngredient::class);
    }
}
