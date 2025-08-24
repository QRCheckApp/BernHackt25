// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TripSummary _$TripSummaryFromJson(Map<String, dynamic> json) {
  return _TripSummary.fromJson(json);
}

/// @nodoc
mixin _$TripSummary {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get destination => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  List<String> get memberIds => throw _privateConstructorUsedError;
  TripStage get stage => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;

  /// Serializes this TripSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripSummaryCopyWith<TripSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripSummaryCopyWith<$Res> {
  factory $TripSummaryCopyWith(
          TripSummary value, $Res Function(TripSummary) then) =
      _$TripSummaryCopyWithImpl<$Res, TripSummary>;
  @useResult
  $Res call(
      {String id,
      String name,
      String destination,
      DateTime startDate,
      DateTime endDate,
      List<String> memberIds,
      TripStage stage,
      String? imagePath});
}

/// @nodoc
class _$TripSummaryCopyWithImpl<$Res, $Val extends TripSummary>
    implements $TripSummaryCopyWith<$Res> {
  _$TripSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? destination = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? memberIds = null,
    Object? stage = null,
    Object? imagePath = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      memberIds: null == memberIds
          ? _value.memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as TripStage,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripSummaryImplCopyWith<$Res>
    implements $TripSummaryCopyWith<$Res> {
  factory _$$TripSummaryImplCopyWith(
          _$TripSummaryImpl value, $Res Function(_$TripSummaryImpl) then) =
      __$$TripSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String destination,
      DateTime startDate,
      DateTime endDate,
      List<String> memberIds,
      TripStage stage,
      String? imagePath});
}

/// @nodoc
class __$$TripSummaryImplCopyWithImpl<$Res>
    extends _$TripSummaryCopyWithImpl<$Res, _$TripSummaryImpl>
    implements _$$TripSummaryImplCopyWith<$Res> {
  __$$TripSummaryImplCopyWithImpl(
      _$TripSummaryImpl _value, $Res Function(_$TripSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? destination = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? memberIds = null,
    Object? stage = null,
    Object? imagePath = freezed,
  }) {
    return _then(_$TripSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      memberIds: null == memberIds
          ? _value._memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as TripStage,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripSummaryImpl implements _TripSummary {
  const _$TripSummaryImpl(
      {required this.id,
      required this.name,
      required this.destination,
      required this.startDate,
      required this.endDate,
      required final List<String> memberIds,
      required this.stage,
      this.imagePath})
      : _memberIds = memberIds;

  factory _$TripSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String destination;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  final List<String> _memberIds;
  @override
  List<String> get memberIds {
    if (_memberIds is EqualUnmodifiableListView) return _memberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberIds);
  }

  @override
  final TripStage stage;
  @override
  final String? imagePath;

  @override
  String toString() {
    return 'TripSummary(id: $id, name: $name, destination: $destination, startDate: $startDate, endDate: $endDate, memberIds: $memberIds, stage: $stage, imagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality()
                .equals(other._memberIds, _memberIds) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      destination,
      startDate,
      endDate,
      const DeepCollectionEquality().hash(_memberIds),
      stage,
      imagePath);

  /// Create a copy of TripSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripSummaryImplCopyWith<_$TripSummaryImpl> get copyWith =>
      __$$TripSummaryImplCopyWithImpl<_$TripSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripSummaryImplToJson(
      this,
    );
  }
}

abstract class _TripSummary implements TripSummary {
  const factory _TripSummary(
      {required final String id,
      required final String name,
      required final String destination,
      required final DateTime startDate,
      required final DateTime endDate,
      required final List<String> memberIds,
      required final TripStage stage,
      final String? imagePath}) = _$TripSummaryImpl;

  factory _TripSummary.fromJson(Map<String, dynamic> json) =
      _$TripSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get destination;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  List<String> get memberIds;
  @override
  TripStage get stage;
  @override
  String? get imagePath;

  /// Create a copy of TripSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripSummaryImplCopyWith<_$TripSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Trip _$TripFromJson(Map<String, dynamic> json) {
  return _Trip.fromJson(json);
}

/// @nodoc
mixin _$Trip {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get destination => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  List<MemberProfile> get members => throw _privateConstructorUsedError;
  TripStage get stage => throw _privateConstructorUsedError;
  List<String> get plannedMeals => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripCopyWith<Trip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) then) =
      _$TripCopyWithImpl<$Res, Trip>;
  @useResult
  $Res call(
      {String id,
      String name,
      String destination,
      DateTime startDate,
      DateTime endDate,
      List<MemberProfile> members,
      TripStage stage,
      List<String> plannedMeals,
      String? imagePath});
}

/// @nodoc
class _$TripCopyWithImpl<$Res, $Val extends Trip>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? destination = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? members = null,
    Object? stage = null,
    Object? plannedMeals = null,
    Object? imagePath = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<MemberProfile>,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as TripStage,
      plannedMeals: null == plannedMeals
          ? _value.plannedMeals
          : plannedMeals // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripImplCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$$TripImplCopyWith(
          _$TripImpl value, $Res Function(_$TripImpl) then) =
      __$$TripImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String destination,
      DateTime startDate,
      DateTime endDate,
      List<MemberProfile> members,
      TripStage stage,
      List<String> plannedMeals,
      String? imagePath});
}

/// @nodoc
class __$$TripImplCopyWithImpl<$Res>
    extends _$TripCopyWithImpl<$Res, _$TripImpl>
    implements _$$TripImplCopyWith<$Res> {
  __$$TripImplCopyWithImpl(_$TripImpl _value, $Res Function(_$TripImpl) _then)
      : super(_value, _then);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? destination = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? members = null,
    Object? stage = null,
    Object? plannedMeals = null,
    Object? imagePath = freezed,
  }) {
    return _then(_$TripImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<MemberProfile>,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as TripStage,
      plannedMeals: null == plannedMeals
          ? _value._plannedMeals
          : plannedMeals // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripImpl implements _Trip {
  const _$TripImpl(
      {required this.id,
      required this.name,
      required this.destination,
      required this.startDate,
      required this.endDate,
      required final List<MemberProfile> members,
      required this.stage,
      final List<String> plannedMeals = const <String>[],
      this.imagePath})
      : _members = members,
        _plannedMeals = plannedMeals;

  factory _$TripImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String destination;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  final List<MemberProfile> _members;
  @override
  List<MemberProfile> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  final TripStage stage;
  final List<String> _plannedMeals;
  @override
  @JsonKey()
  List<String> get plannedMeals {
    if (_plannedMeals is EqualUnmodifiableListView) return _plannedMeals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_plannedMeals);
  }

  @override
  final String? imagePath;

  @override
  String toString() {
    return 'Trip(id: $id, name: $name, destination: $destination, startDate: $startDate, endDate: $endDate, members: $members, stage: $stage, plannedMeals: $plannedMeals, imagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            const DeepCollectionEquality()
                .equals(other._plannedMeals, _plannedMeals) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      destination,
      startDate,
      endDate,
      const DeepCollectionEquality().hash(_members),
      stage,
      const DeepCollectionEquality().hash(_plannedMeals),
      imagePath);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      __$$TripImplCopyWithImpl<_$TripImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripImplToJson(
      this,
    );
  }
}

abstract class _Trip implements Trip {
  const factory _Trip(
      {required final String id,
      required final String name,
      required final String destination,
      required final DateTime startDate,
      required final DateTime endDate,
      required final List<MemberProfile> members,
      required final TripStage stage,
      final List<String> plannedMeals,
      final String? imagePath}) = _$TripImpl;

  factory _Trip.fromJson(Map<String, dynamic> json) = _$TripImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get destination;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  List<MemberProfile> get members;
  @override
  TripStage get stage;
  @override
  List<String> get plannedMeals;
  @override
  String? get imagePath;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
