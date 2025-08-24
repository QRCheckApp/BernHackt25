// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitchen_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KitchenProfileImpl _$$KitchenProfileImplFromJson(Map<String, dynamic> json) =>
    _$KitchenProfileImpl(
      groupId: json['groupId'] as String,
      heatSources: (json['heatSources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      appliances: (json['appliances'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      burners: (json['burners'] as num?)?.toInt() ?? 2,
      ovenCapacity: (json['ovenCapacity'] as num?)?.toInt() ?? 1,
      constraints: (json['constraints'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$$KitchenProfileImplToJson(
        _$KitchenProfileImpl instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'heatSources': instance.heatSources,
      'appliances': instance.appliances,
      'burners': instance.burners,
      'ovenCapacity': instance.ovenCapacity,
      'constraints': instance.constraints,
    };
