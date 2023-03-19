import 'package:freezed_annotation/freezed_annotation.dart';
part 'obs_receive_message.freezed.dart';
part 'obs_receive_message.g.dart';

@freezed
class ObsReceiveMessage with _$ObsReceiveMessage {
  /// OBSに送信するメッセージ
  ///
  /// [op] OpCodes
  /// [d] Data
  const factory ObsReceiveMessage({required int op}) = _ObsReceiveMessage;

  factory ObsReceiveMessage.fromJson(Map<String, dynamic> json) =>
      _$ObsReceiveMessageFromJson(json);
}
