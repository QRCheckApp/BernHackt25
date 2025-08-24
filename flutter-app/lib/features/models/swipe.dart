import 'package:freezed_annotation/freezed_annotation.dart';

part 'swipe.freezed.dart';
part 'swipe.g.dart';

@freezed
class Swipe with _$Swipe {
  const factory Swipe({
    required String recipeId,
    required String memberId,
    required int vote, // -1 dislike, +1 like, +3 superlike
    required DateTime ts,
  }) = _Swipe;
  factory Swipe.fromJson(Map<String, dynamic> json) => _$SwipeFromJson(json);
}
