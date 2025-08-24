// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kitchen_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KitchenProfile _$KitchenProfileFromJson(Map<String, dynamic> json) {
  return _KitchenProfile.fromJson(json);
}

/// @nodoc
mixin _$KitchenProfile {
  String get groupId => throw _privateConstructorUsedError;
  List<String> get heatSources =>
      throw _privateConstructorUsedError; // stove, oven, grill
  List<String> get appliances =>
      throw _privateConstructorUsedError; // pot, pan, baking_tray, blender
  int get burners => throw _privateConstructorUsedError;
  int get ovenCapacity => throw _privateConstructorUsedError;
  List<String> get constraints => throw _privateConstructorUsedError;

  /// Serializes this KitchenProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KitchenProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KitchenProfileCopyWith<KitchenProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KitchenProfileCopyWith<$Res> {
  factory $KitchenProfileCopyWith(
          KitchenProfile value, $Res Function(KitchenProfile) then) =
      _$KitchenProfileCopyWithImpl<$Res, KitchenProfile>;
  @useResult
  $Res call(
      {String groupId,
      List<String> heatSources,
      List<String> appliances,
      int burners,
      int ovenCapacity,
      List<String> constraints});
}

/// @nodoc
class _$KitchenProfileCopyWithImpl<$Res, $Val extends KitchenProfile>
    implements $KitchenProfileCopyWith<$Res> {
  _$KitchenProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KitchenProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? heatSources = null,
    Object? appliances = null,
    Object? burners = null,
    Object? ovenCapacity = null,
    Object? constraints = null,
  }) {
    return _then(_value.copyWith(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      heatSources: null == heatSources
          ? _value.heatSources
          : heatSources // ignore: cast_nullable_to_non_nullable
              as List<String>,
      appliances: null == appliances
          ? _value.appliances
          : appliances // ignore: cast_nullable_to_non_nullable
              as List<String>,
      burners: null == burners
          ? _value.burners
          : burners // ignore: cast_nullable_to_non_nullable
              as int,
      ovenCapacity: null == ovenCapacity
          ? _value.ovenCapacity
          : ovenCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      constraints: null == constraints
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KitchenProfileImplCopyWith<$Res>
    implements $KitchenProfileCopyWith<$Res> {
  factory _$$KitchenProfileImplCopyWith(_$KitchenProfileImpl value,
          $Res Function(_$KitchenProfileImpl) then) =
      __$$KitchenProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String groupId,
      List<String> heatSources,
      List<String> appliances,
      int burners,
      int ovenCapacity,
      List<String> constraints});
}

/// @nodoc
class __$$KitchenProfileImplCopyWithImpl<$Res>
    extends _$KitchenProfileCopyWithImpl<$Res, _$KitchenProfileImpl>
    implements _$$KitchenProfileImplCopyWith<$Res> {
  __$$KitchenProfileImplCopyWithImpl(
      _$KitchenProfileImpl _value, $Res Function(_$KitchenProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of KitchenProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? heatSources = null,
    Object? appliances = null,
    Object? burners = null,
    Object? ovenCapacity = null,
    Object? constraints = null,
  }) {
    return _then(_$KitchenProfileImpl(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      heatSources: null == heatSources
          ? _value._heatSources
          : heatSources // ignore: cast_nullable_to_non_nullable
              as List<String>,
      appliances: null == appliances
          ? _value._appliances
          : appliances // ignore: cast_nullable_to_non_nullable
              as List<String>,
      burners: null == burners
          ? _value.burners
          : burners // ignore: cast_nullable_to_non_nullable
              as int,
      ovenCapacity: null == ovenCapacity
          ? _value.ovenCapacity
          : ovenCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      constraints: null == constraints
          ? _value._constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KitchenProfileImpl implements _KitchenProfile {
  const _$KitchenProfileImpl(
      {required this.groupId,
      final List<String> heatSources = const <String>[],
      final List<String> appliances = const <String>[],
      this.burners = 2,
      this.ovenCapacity = 1,
      final List<String> constraints = const <String>[]})
      : _heatSources = heatSources,
        _appliances = appliances,
        _constraints = constraints;

  factory _$KitchenProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$KitchenProfileImplFromJson(json);

  @override
  final String groupId;
  final List<String> _heatSources;
  @override
  @JsonKey()
  List<String> get heatSources {
    if (_heatSources is EqualUnmodifiableListView) return _heatSources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_heatSources);
  }

// stove, oven, grill
  final List<String> _appliances;
// stove, oven, grill
  @override
  @JsonKey()
  List<String> get appliances {
    if (_appliances is EqualUnmodifiableListView) return _appliances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appliances);
  }

// pot, pan, baking_tray, blender
  @override
  @JsonKey()
  final int burners;
  @override
  @JsonKey()
  final int ovenCapacity;
  final List<String> _constraints;
  @override
  @JsonKey()
  List<String> get constraints {
    if (_constraints is EqualUnmodifiableListView) return _constraints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_constraints);
  }

  @override
  String toString() {
    return 'KitchenProfile(groupId: $groupId, heatSources: $heatSources, appliances: $appliances, burners: $burners, ovenCapacity: $ovenCapacity, constraints: $constraints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KitchenProfileImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            const DeepCollectionEquality()
                .equals(other._heatSources, _heatSources) &&
            const DeepCollectionEquality()
                .equals(other._appliances, _appliances) &&
            (identical(other.burners, burners) || other.burners == burners) &&
            (identical(other.ovenCapacity, ovenCapacity) ||
                other.ovenCapacity == ovenCapacity) &&
            const DeepCollectionEquality()
                .equals(other._constraints, _constraints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      groupId,
      const DeepCollectionEquality().hash(_heatSources),
      const DeepCollectionEquality().hash(_appliances),
      burners,
      ovenCapacity,
      const DeepCollectionEquality().hash(_constraints));

  /// Create a copy of KitchenProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KitchenProfileImplCopyWith<_$KitchenProfileImpl> get copyWith =>
      __$$KitchenProfileImplCopyWithImpl<_$KitchenProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KitchenProfileImplToJson(
      this,
    );
  }
}

abstract class _KitchenProfile implements KitchenProfile {
  const factory _KitchenProfile(
      {required final String groupId,
      final List<String> heatSources,
      final List<String> appliances,
      final int burners,
      final int ovenCapacity,
      final List<String> constraints}) = _$KitchenProfileImpl;

  factory _KitchenProfile.fromJson(Map<String, dynamic> json) =
      _$KitchenProfileImpl.fromJson;

  @override
  String get groupId;
  @override
  List<String> get heatSources; // stove, oven, grill
  @override
  List<String> get appliances; // pot, pan, baking_tray, blender
  @override
  int get burners;
  @override
  int get ovenCapacity;
  @override
  List<String> get constraints;

  /// Create a copy of KitchenProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KitchenProfileImplCopyWith<_$KitchenProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
