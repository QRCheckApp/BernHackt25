import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
class MemberProfile with _$MemberProfile {
  const factory MemberProfile({
    required String memberId,
    required String name,
    required String diet,       // "omnivore"|"vegetarian"|"vegan"|"pescetarian"
    @Default(<String>[]) List<String> allergies,
    @Default(<String>[]) List<String> dislikes,
    @Default(true) bool alcoholOk,
    @Default(true) bool caffeineOk,
  }) = _MemberProfile;
  factory MemberProfile.fromJson(Map<String, dynamic> json) => _$MemberProfileFromJson(json);
}

@freezed
class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    required int days,
    required List<MemberProfile> members,
    @Default("CHF") String currency,
  }) = _Group;
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
