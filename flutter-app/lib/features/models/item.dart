import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
class Item with _$Item {
  const factory Item({
    required String id,
    required String name,
    required String category, // pasta, dairy, produce, canned, meat, beverage, etc.
    required String baseUnit, // "g" | "ml" | "pcs"
    required double packSizeBase,
    String? vendorSku,
  }) = _Item;
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
