// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberProfileImpl _$$MemberProfileImplFromJson(Map<String, dynamic> json) =>
    _$MemberProfileImpl(
      memberId: json['memberId'] as String,
      name: json['name'] as String,
      diet: json['diet'] as String,
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      dislikes: (json['dislikes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      alcoholOk: json['alcoholOk'] as bool? ?? true,
      caffeineOk: json['caffeineOk'] as bool? ?? true,
    );

Map<String, dynamic> _$$MemberProfileImplToJson(_$MemberProfileImpl instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'name': instance.name,
      'diet': instance.diet,
      'allergies': instance.allergies,
      'dislikes': instance.dislikes,
      'alcoholOk': instance.alcoholOk,
      'caffeineOk': instance.caffeineOk,
    };

_$GroupImpl _$$GroupImplFromJson(Map<String, dynamic> json) => _$GroupImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      days: (json['days'] as num).toInt(),
      members: (json['members'] as List<dynamic>)
          .map((e) => MemberProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      currency: json['currency'] as String? ?? "CHF",
    );

Map<String, dynamic> _$$GroupImplToJson(_$GroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'days': instance.days,
      'members': instance.members,
      'currency': instance.currency,
    };
