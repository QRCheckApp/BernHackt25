// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripSummaryImpl _$$TripSummaryImplFromJson(Map<String, dynamic> json) =>
    _$TripSummaryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      destination: json['destination'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      memberIds:
          (json['memberIds'] as List<dynamic>).map((e) => e as String).toList(),
      stage: $enumDecode(_$TripStageEnumMap, json['stage']),
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$$TripSummaryImplToJson(_$TripSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'destination': instance.destination,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'memberIds': instance.memberIds,
      'stage': _$TripStageEnumMap[instance.stage]!,
      'imagePath': instance.imagePath,
    };

const _$TripStageEnumMap = {
  TripStage.stage1: 'stage1',
  TripStage.stage2: 'stage2',
};

_$TripImpl _$$TripImplFromJson(Map<String, dynamic> json) => _$TripImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      destination: json['destination'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      members: (json['members'] as List<dynamic>)
          .map((e) => MemberProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      stage: $enumDecode(_$TripStageEnumMap, json['stage']),
      plannedMeals: (json['plannedMeals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$$TripImplToJson(_$TripImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'destination': instance.destination,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'members': instance.members,
      'stage': _$TripStageEnumMap[instance.stage]!,
      'plannedMeals': instance.plannedMeals,
      'imagePath': instance.imagePath,
    };
