import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ikut3/data/websocket/obs_event_data.dart';
part 'obs_receive_message_data.freezed.dart';
part 'obs_receive_message_data.g.dart';

@freezed
class ObsReceiveMessageData with _$ObsReceiveMessageData {
  const factory ObsReceiveMessageData(
      {String? eventType, ObsEventData? eventData}) = _ObsReceiveMessageData;

  factory ObsReceiveMessageData.fromJson(Map<String, dynamic> json) =>
      _$ObsReceiveMessageDataFromJson(json);
}
