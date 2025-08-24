import 'package:freezed_annotation/freezed_annotation.dart';

part 'kitchen_profile.freezed.dart';
part 'kitchen_profile.g.dart';

@freezed
class KitchenProfile with _$KitchenProfile {
  const factory KitchenProfile({
    required String groupId,
    @Default(<String>[]) List<String> heatSources, // stove, oven, grill
    @Default(<String>[]) List<String> appliances,  // pot, pan, baking_tray, blender
    @Default(2) int burners,
    @Default(1) int ovenCapacity,
    @Default(<String>[]) List<String> constraints, // no_oven, tiny_fridge
  }) = _KitchenProfile;
  factory KitchenProfile.fromJson(Map<String, dynamic> json) => _$KitchenProfileFromJson(json);
}
