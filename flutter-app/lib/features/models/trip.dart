import 'package:freezed_annotation/freezed_annotation.dart';
import 'group.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

enum TripStage { stage1, stage2 }

@freezed
class TripSummary with _$TripSummary {
  const factory TripSummary({
    required String id,
    required String name,
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> memberIds,
    required TripStage stage,
    String? imagePath,
  }) = _TripSummary;
  factory TripSummary.fromJson(Map<String, dynamic> json) => _$TripSummaryFromJson(json);
}

@freezed
class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String name,
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required List<MemberProfile> members,
    required TripStage stage,
    @Default(<String>[]) List<String> plannedMeals,
    String? imagePath,
  }) = _Trip;
  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}
