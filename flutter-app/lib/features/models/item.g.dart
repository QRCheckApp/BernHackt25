// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemImpl _$$ItemImplFromJson(Map<String, dynamic> json) => _$ItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      baseUnit: json['baseUnit'] as String,
      packSizeBase: (json['packSizeBase'] as num).toDouble(),
      vendorSku: json['vendorSku'] as String?,
    );

Map<String, dynamic> _$$ItemImplToJson(_$ItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'baseUnit': instance.baseUnit,
      'packSizeBase': instance.packSizeBase,
      'vendorSku': instance.vendorSku,
    };
