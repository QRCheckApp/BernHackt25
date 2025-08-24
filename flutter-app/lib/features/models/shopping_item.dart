import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_item.freezed.dart';
part 'shopping_item.g.dart';

@freezed
class ShoppingItem with _$ShoppingItem {
  const factory ShoppingItem({
    required String id,
    required String name,
    required String category,
    required double quantity,
    required String unit,
    required bool isCompleted,
    String? assignedTo,
    String? notes,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _ShoppingItem;
  
  factory ShoppingItem.fromJson(Map<String, dynamic> json) => _$ShoppingItemFromJson(json);
}

@freezed
class ShoppingList with _$ShoppingList {
  const factory ShoppingList({
    required String tripId,
    required List<ShoppingItem> items,
    required DateTime lastUpdated,
  }) = _ShoppingList;
  
  factory ShoppingList.fromJson(Map<String, dynamic> json) => _$ShoppingListFromJson(json);
}
