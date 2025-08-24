<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\RecipeController;

Route::post('/recipes/generate', [RecipeController::class, 'generate']);
