<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('recipes', function (Blueprint $table) {
            $table->id();
            $table->string('slug')->unique();
            $table->string('title');
            $table->integer('servings_base');
            $table->json('tags')->nullable();
            $table->json('satisfies')->nullable();
            $table->json('excludes_allergens')->nullable();
            $table->json('appliance_requirements')->nullable();
            $table->json('steps')->nullable();
            $table->integer('est_prep_min')->nullable();
            $table->integer('est_cook_min')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('recipes');
    }
};
