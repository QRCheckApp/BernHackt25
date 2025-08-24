// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SwipeImpl _$$SwipeImplFromJson(Map<String, dynamic> json) => _$SwipeImpl(
      recipeId: json['recipeId'] as String,
      memberId: json['memberId'] as String,
      vote: (json['vote'] as num).toInt(),
      ts: DateTime.parse(json['ts'] as String),
    );

Map<String, dynamic> _$$SwipeImplToJson(_$SwipeImpl instance) =>
    <String, dynamic>{
      'recipeId': instance.recipeId,
      'memberId': instance.memberId,
      'vote': instance.vote,
      'ts': instance.ts.toIso8601String(),
    };
