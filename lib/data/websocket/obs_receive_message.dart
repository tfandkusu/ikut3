import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ikut3/data/websocket/obs_receive_message_data.dart';
part 'obs_receive_message.freezed.dart';
part 'obs_receive_message.g.dart';

@freezed
class ObsReceiveMessage with _$ObsReceiveMessage {
  /// OBSから受信するメッセージ
  ///
  /// [op] OpCodes
  /// [d] Data
  const factory ObsReceiveMessage(
      {required int op, required ObsReceiveMessageData d}) = _ObsReceiveMessage;

  factory ObsReceiveMessage.fromJson(Map<String, dynamic> json) =>
      _$ObsReceiveMessageFromJson(json);
}
