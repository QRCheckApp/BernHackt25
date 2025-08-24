import 'package:freezed_annotation/freezed_annotation.dart';

part 'luggage_item.freezed.dart';
part 'luggage_item.g.dart';

@freezed
class LuggageItem with _$LuggageItem {
  const factory LuggageItem({
    required String id,
    required String name,
    required String category,
    required double quantity,
    required String unit,
    required bool isPacked,
    String? assignedTo,
    String? notes,
    required DateTime createdAt,
    DateTime? packedAt,
    String? originalShoppingItemId, // Optional reference to the original shopping item
  }) = _LuggageItem;
  
  factory LuggageItem.fromJson(Map<String, dynamic> json) => _$LuggageItemFromJson(json);
}

@freezed
class LuggageList with _$LuggageList {
  const factory LuggageList({
    required String tripId,
    required List<LuggageItem> items,
    required DateTime lastUpdated,
  }) = _LuggageList;
  
  factory LuggageList.fromJson(Map<String, dynamic> json) => _$LuggageListFromJson(json);
}
