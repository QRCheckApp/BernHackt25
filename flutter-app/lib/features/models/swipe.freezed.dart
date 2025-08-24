// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Swipe _$SwipeFromJson(Map<String, dynamic> json) {
  return _Swipe.fromJson(json);
}

/// @nodoc
mixin _$Swipe {
  String get recipeId => throw _privateConstructorUsedError;
  String get memberId => throw _privateConstructorUsedError;
  int get vote =>
      throw _privateConstructorUsedError; // -1 dislike, +1 like, +3 superlike
  DateTime get ts => throw _privateConstructorUsedError;

  /// Serializes this Swipe to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Swipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwipeCopyWith<Swipe> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwipeCopyWith<$Res> {
  factory $SwipeCopyWith(Swipe value, $Res Function(Swipe) then) =
      _$SwipeCopyWithImpl<$Res, Swipe>;
  @useResult
  $Res call({String recipeId, String memberId, int vote, DateTime ts});
}

/// @nodoc
class _$SwipeCopyWithImpl<$Res, $Val extends Swipe>
    implements $SwipeCopyWith<$Res> {
  _$SwipeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Swipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipeId = null,
    Object? memberId = null,
    Object? vote = null,
    Object? ts = null,
  }) {
    return _then(_value.copyWith(
      recipeId: null == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      vote: null == vote
          ? _value.vote
          : vote // ignore: cast_nullable_to_non_nullable
              as int,
      ts: null == ts
          ? _value.ts
          : ts // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SwipeImplCopyWith<$Res> implements $SwipeCopyWith<$Res> {
  factory _$$SwipeImplCopyWith(
          _$SwipeImpl value, $Res Function(_$SwipeImpl) then) =
      __$$SwipeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String recipeId, String memberId, int vote, DateTime ts});
}

/// @nodoc
class __$$SwipeImplCopyWithImpl<$Res>
    extends _$SwipeCopyWithImpl<$Res, _$SwipeImpl>
    implements _$$SwipeImplCopyWith<$Res> {
  __$$SwipeImplCopyWithImpl(
      _$SwipeImpl _value, $Res Function(_$SwipeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Swipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipeId = null,
    Object? memberId = null,
    Object? vote = null,
    Object? ts = null,
  }) {
    return _then(_$SwipeImpl(
      recipeId: null == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      vote: null == vote
          ? _value.vote
          : vote // ignore: cast_nullable_to_non_nullable
              as int,
      ts: null == ts
          ? _value.ts
          : ts // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SwipeImpl implements _Swipe {
  const _$SwipeImpl(
      {required this.recipeId,
      required this.memberId,
      required this.vote,
      required this.ts});

  factory _$SwipeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SwipeImplFromJson(json);

  @override
  final String recipeId;
  @override
  final String memberId;
  @override
  final int vote;
// -1 dislike, +1 like, +3 superlike
  @override
  final DateTime ts;

  @override
  String toString() {
    return 'Swipe(recipeId: $recipeId, memberId: $memberId, vote: $vote, ts: $ts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwipeImpl &&
            (identical(other.recipeId, recipeId) ||
                other.recipeId == recipeId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.vote, vote) || other.vote == vote) &&
            (identical(other.ts, ts) || other.ts == ts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, recipeId, memberId, vote, ts);

  /// Create a copy of Swipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwipeImplCopyWith<_$SwipeImpl> get copyWith =>
      __$$SwipeImplCopyWithImpl<_$SwipeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SwipeImplToJson(
      this,
    );
  }
}

abstract class _Swipe implements Swipe {
  const factory _Swipe(
      {required final String recipeId,
      required final String memberId,
      required final int vote,
      required final DateTime ts}) = _$SwipeImpl;

  factory _Swipe.fromJson(Map<String, dynamic> json) = _$SwipeImpl.fromJson;

  @override
  String get recipeId;
  @override
  String get memberId;
  @override
  int get vote; // -1 dislike, +1 like, +3 superlike
  @override
  DateTime get ts;

  /// Create a copy of Swipe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwipeImplCopyWith<_$SwipeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
