// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return _Recipe.fromJson(json);
}

/// @nodoc
mixin _$Recipe {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get servingsBase => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<String> get satisfies =>
      throw _privateConstructorUsedError; // e.g., ["omnivore","vegetarian","vegan"]
  List<String> get excludesAllergens =>
      throw _privateConstructorUsedError; // e.g., ["nuts","shellfish"]
  List<String> get applianceRequirements =>
      throw _privateConstructorUsedError; // ["stove","oven","grill"]
  List<RecipeIngredient> get ingredients => throw _privateConstructorUsedError;
  List<String> get steps => throw _privateConstructorUsedError;
  int get estPrepMin => throw _privateConstructorUsedError;
  int get estCookMin => throw _privateConstructorUsedError;

  /// Serializes this Recipe to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeCopyWith<Recipe> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeCopyWith<$Res> {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) then) =
      _$RecipeCopyWithImpl<$Res, Recipe>;
  @useResult
  $Res call(
      {String id,
      String title,
      int servingsBase,
      List<String> tags,
      List<String> satisfies,
      List<String> excludesAllergens,
      List<String> applianceRequirements,
      List<RecipeIngredient> ingredients,
      List<String> steps,
      int estPrepMin,
      int estCookMin});
}

/// @nodoc
class _$RecipeCopyWithImpl<$Res, $Val extends Recipe>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? servingsBase = null,
    Object? tags = null,
    Object? satisfies = null,
    Object? excludesAllergens = null,
    Object? applianceRequirements = null,
    Object? ingredients = null,
    Object? steps = null,
    Object? estPrepMin = null,
    Object? estCookMin = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      servingsBase: null == servingsBase
          ? _value.servingsBase
          : servingsBase // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      satisfies: null == satisfies
          ? _value.satisfies
          : satisfies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      excludesAllergens: null == excludesAllergens
          ? _value.excludesAllergens
          : excludesAllergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      applianceRequirements: null == applianceRequirements
          ? _value.applianceRequirements
          : applianceRequirements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<RecipeIngredient>,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      estPrepMin: null == estPrepMin
          ? _value.estPrepMin
          : estPrepMin // ignore: cast_nullable_to_non_nullable
              as int,
      estCookMin: null == estCookMin
          ? _value.estCookMin
          : estCookMin // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeImplCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$$RecipeImplCopyWith(
          _$RecipeImpl value, $Res Function(_$RecipeImpl) then) =
      __$$RecipeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      int servingsBase,
      List<String> tags,
      List<String> satisfies,
      List<String> excludesAllergens,
      List<String> applianceRequirements,
      List<RecipeIngredient> ingredients,
      List<String> steps,
      int estPrepMin,
      int estCookMin});
}

/// @nodoc
class __$$RecipeImplCopyWithImpl<$Res>
    extends _$RecipeCopyWithImpl<$Res, _$RecipeImpl>
    implements _$$RecipeImplCopyWith<$Res> {
  __$$RecipeImplCopyWithImpl(
      _$RecipeImpl _value, $Res Function(_$RecipeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? servingsBase = null,
    Object? tags = null,
    Object? satisfies = null,
    Object? excludesAllergens = null,
    Object? applianceRequirements = null,
    Object? ingredients = null,
    Object? steps = null,
    Object? estPrepMin = null,
    Object? estCookMin = null,
  }) {
    return _then(_$RecipeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      servingsBase: null == servingsBase
          ? _value.servingsBase
          : servingsBase // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      satisfies: null == satisfies
          ? _value._satisfies
          : satisfies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      excludesAllergens: null == excludesAllergens
          ? _value._excludesAllergens
          : excludesAllergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      applianceRequirements: null == applianceRequirements
          ? _value._applianceRequirements
          : applianceRequirements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<RecipeIngredient>,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      estPrepMin: null == estPrepMin
          ? _value.estPrepMin
          : estPrepMin // ignore: cast_nullable_to_non_nullable
              as int,
      estCookMin: null == estCookMin
          ? _value.estCookMin
          : estCookMin // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeImpl implements _Recipe {
  const _$RecipeImpl(
      {required this.id,
      required this.title,
      required this.servingsBase,
      required final List<String> tags,
      required final List<String> satisfies,
      required final List<String> excludesAllergens,
      required final List<String> applianceRequirements,
      required final List<RecipeIngredient> ingredients,
      required final List<String> steps,
      required this.estPrepMin,
      required this.estCookMin})
      : _tags = tags,
        _satisfies = satisfies,
        _excludesAllergens = excludesAllergens,
        _applianceRequirements = applianceRequirements,
        _ingredients = ingredients,
        _steps = steps;

  factory _$RecipeImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final int servingsBase;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _satisfies;
  @override
  List<String> get satisfies {
    if (_satisfies is EqualUnmodifiableListView) return _satisfies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_satisfies);
  }

// e.g., ["omnivore","vegetarian","vegan"]
  final List<String> _excludesAllergens;
// e.g., ["omnivore","vegetarian","vegan"]
  @override
  List<String> get excludesAllergens {
    if (_excludesAllergens is EqualUnmodifiableListView)
      return _excludesAllergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_excludesAllergens);
  }

// e.g., ["nuts","shellfish"]
  final List<String> _applianceRequirements;
// e.g., ["nuts","shellfish"]
  @override
  List<String> get applianceRequirements {
    if (_applianceRequirements is EqualUnmodifiableListView)
      return _applianceRequirements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applianceRequirements);
  }

// ["stove","oven","grill"]
  final List<RecipeIngredient> _ingredients;
// ["stove","oven","grill"]
  @override
  List<RecipeIngredient> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<String> _steps;
  @override
  List<String> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  final int estPrepMin;
  @override
  final int estCookMin;

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, servingsBase: $servingsBase, tags: $tags, satisfies: $satisfies, excludesAllergens: $excludesAllergens, applianceRequirements: $applianceRequirements, ingredients: $ingredients, steps: $steps, estPrepMin: $estPrepMin, estCookMin: $estCookMin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.servingsBase, servingsBase) ||
                other.servingsBase == servingsBase) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._satisfies, _satisfies) &&
            const DeepCollectionEquality()
                .equals(other._excludesAllergens, _excludesAllergens) &&
            const DeepCollectionEquality()
                .equals(other._applianceRequirements, _applianceRequirements) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.estPrepMin, estPrepMin) ||
                other.estPrepMin == estPrepMin) &&
            (identical(other.estCookMin, estCookMin) ||
                other.estCookMin == estCookMin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      servingsBase,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_satisfies),
      const DeepCollectionEquality().hash(_excludesAllergens),
      const DeepCollectionEquality().hash(_applianceRequirements),
      const DeepCollectionEquality().hash(_ingredients),
      const DeepCollectionEquality().hash(_steps),
      estPrepMin,
      estCookMin);

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      __$$RecipeImplCopyWithImpl<_$RecipeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeImplToJson(
      this,
    );
  }
}

abstract class _Recipe implements Recipe {
  const factory _Recipe(
      {required final String id,
      required final String title,
      required final int servingsBase,
      required final List<String> tags,
      required final List<String> satisfies,
      required final List<String> excludesAllergens,
      required final List<String> applianceRequirements,
      required final List<RecipeIngredient> ingredients,
      required final List<String> steps,
      required final int estPrepMin,
      required final int estCookMin}) = _$RecipeImpl;

  factory _Recipe.fromJson(Map<String, dynamic> json) = _$RecipeImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  int get servingsBase;
  @override
  List<String> get tags;
  @override
  List<String> get satisfies; // e.g., ["omnivore","vegetarian","vegan"]
  @override
  List<String> get excludesAllergens; // e.g., ["nuts","shellfish"]
  @override
  List<String> get applianceRequirements; // ["stove","oven","grill"]
  @override
  List<RecipeIngredient> get ingredients;
  @override
  List<String> get steps;
  @override
  int get estPrepMin;
  @override
  int get estCookMin;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) {
  return _RecipeIngredient.fromJson(json);
}

/// @nodoc
mixin _$RecipeIngredient {
  String get itemName =>
      throw _privateConstructorUsedError; // canonical name (maps to Item later)
  double get qty => throw _privateConstructorUsedError;
  String get unit =>
      throw _privateConstructorUsedError; // "g"|"kg"|"ml"|"l"|"pcs"
  String get category => throw _privateConstructorUsedError;

  /// Serializes this RecipeIngredient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeIngredientCopyWith<RecipeIngredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeIngredientCopyWith<$Res> {
  factory $RecipeIngredientCopyWith(
          RecipeIngredient value, $Res Function(RecipeIngredient) then) =
      _$RecipeIngredientCopyWithImpl<$Res, RecipeIngredient>;
  @useResult
  $Res call({String itemName, double qty, String unit, String category});
}

/// @nodoc
class _$RecipeIngredientCopyWithImpl<$Res, $Val extends RecipeIngredient>
    implements $RecipeIngredientCopyWith<$Res> {
  _$RecipeIngredientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemName = null,
    Object? qty = null,
    Object? unit = null,
    Object? category = null,
  }) {
    return _then(_value.copyWith(
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      qty: null == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeIngredientImplCopyWith<$Res>
    implements $RecipeIngredientCopyWith<$Res> {
  factory _$$RecipeIngredientImplCopyWith(_$RecipeIngredientImpl value,
          $Res Function(_$RecipeIngredientImpl) then) =
      __$$RecipeIngredientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String itemName, double qty, String unit, String category});
}

/// @nodoc
class __$$RecipeIngredientImplCopyWithImpl<$Res>
    extends _$RecipeIngredientCopyWithImpl<$Res, _$RecipeIngredientImpl>
    implements _$$RecipeIngredientImplCopyWith<$Res> {
  __$$RecipeIngredientImplCopyWithImpl(_$RecipeIngredientImpl _value,
      $Res Function(_$RecipeIngredientImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemName = null,
    Object? qty = null,
    Object? unit = null,
    Object? category = null,
  }) {
    return _then(_$RecipeIngredientImpl(
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      qty: null == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeIngredientImpl implements _RecipeIngredient {
  const _$RecipeIngredientImpl(
      {required this.itemName,
      required this.qty,
      required this.unit,
      required this.category});

  factory _$RecipeIngredientImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeIngredientImplFromJson(json);

  @override
  final String itemName;
// canonical name (maps to Item later)
  @override
  final double qty;
  @override
  final String unit;
// "g"|"kg"|"ml"|"l"|"pcs"
  @override
  final String category;

  @override
  String toString() {
    return 'RecipeIngredient(itemName: $itemName, qty: $qty, unit: $unit, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeIngredientImpl &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, itemName, qty, unit, category);

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeIngredientImplCopyWith<_$RecipeIngredientImpl> get copyWith =>
      __$$RecipeIngredientImplCopyWithImpl<_$RecipeIngredientImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeIngredientImplToJson(
      this,
    );
  }
}

abstract class _RecipeIngredient implements RecipeIngredient {
  const factory _RecipeIngredient(
      {required final String itemName,
      required final double qty,
      required final String unit,
      required final String category}) = _$RecipeIngredientImpl;

  factory _RecipeIngredient.fromJson(Map<String, dynamic> json) =
      _$RecipeIngredientImpl.fromJson;

  @override
  String get itemName; // canonical name (maps to Item later)
  @override
  double get qty;
  @override
  String get unit; // "g"|"kg"|"ml"|"l"|"pcs"
  @override
  String get category;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeIngredientImplCopyWith<_$RecipeIngredientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
