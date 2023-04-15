import 'package:freezed_annotation/freezed_annotation.dart';
part 'obs_event_data.freezed.dart';
part 'obs_event_data.g.dart';

@freezed
class ObsEventData with _$ObsEventData {
  const factory ObsEventData(
      {String? savedReplayPath,
      bool? outputActive,
      String? outputState}) = _ObsEventData;

  factory ObsEventData.fromJson(Map<String, dynamic> json) =>
      _$ObsEventDataFromJson(json);
}
