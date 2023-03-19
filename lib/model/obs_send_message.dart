import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ikut3/model/obs_message_data.dart';
part 'obs_send_message.freezed.dart';
part 'obs_send_message.g.dart';

@freezed
class ObsSendMessage with _$ObsSendMessage {
  /// OBSに送信するメッセージ
  ///
  /// [op] OpCodes
  /// [d] Data
  ///
  const factory ObsSendMessage({required int op, required ObsMessageData d}) =
      _ObsSendMessage;

  factory ObsSendMessage.fromJson(Map<String, dynamic> json) =>
      _$ObsSendMessageFromJson(json);
}
