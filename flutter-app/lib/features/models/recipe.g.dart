// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeImpl _$$RecipeImplFromJson(Map<String, dynamic> json) => _$RecipeImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      servingsBase: (json['servingsBase'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      satisfies:
          (json['satisfies'] as List<dynamic>).map((e) => e as String).toList(),
      excludesAllergens: (json['excludesAllergens'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      applianceRequirements: (json['applianceRequirements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      estPrepMin: (json['estPrepMin'] as num).toInt(),
      estCookMin: (json['estCookMin'] as num).toInt(),
    );

Map<String, dynamic> _$$RecipeImplToJson(_$RecipeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'servingsBase': instance.servingsBase,
      'tags': instance.tags,
      'satisfies': instance.satisfies,
      'excludesAllergens': instance.excludesAllergens,
      'applianceRequirements': instance.applianceRequirements,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
      'estPrepMin': instance.estPrepMin,
      'estCookMin': instance.estCookMin,
    };

_$RecipeIngredientImpl _$$RecipeIngredientImplFromJson(
        Map<String, dynamic> json) =>
    _$RecipeIngredientImpl(
      itemName: json['itemName'] as String,
      qty: (json['qty'] as num).toDouble(),
      unit: json['unit'] as String,
      category: json['category'] as String,
    );

Map<String, dynamic> _$$RecipeIngredientImplToJson(
        _$RecipeIngredientImpl instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'qty': instance.qty,
      'unit': instance.unit,
      'category': instance.category,
    };
