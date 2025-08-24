// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'luggage_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LuggageItemImpl _$$LuggageItemImplFromJson(Map<String, dynamic> json) =>
    _$LuggageItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      isPacked: json['isPacked'] as bool,
      assignedTo: json['assignedTo'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      packedAt: json['packedAt'] == null
          ? null
          : DateTime.parse(json['packedAt'] as String),
      originalShoppingItemId: json['originalShoppingItemId'] as String?,
    );

Map<String, dynamic> _$$LuggageItemImplToJson(_$LuggageItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'isPacked': instance.isPacked,
      'assignedTo': instance.assignedTo,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'packedAt': instance.packedAt?.toIso8601String(),
      'originalShoppingItemId': instance.originalShoppingItemId,
    };

_$LuggageListImpl _$$LuggageListImplFromJson(Map<String, dynamic> json) =>
    _$LuggageListImpl(
      tripId: json['tripId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => LuggageItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$LuggageListImplToJson(_$LuggageListImpl instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'items': instance.items,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
