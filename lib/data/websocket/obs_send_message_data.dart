import 'package:freezed_annotation/freezed_annotation.dart';
part 'obs_send_message_data.freezed.dart';
part 'obs_send_message_data.g.dart';

/// OBSとやりとりするためのメッセージのdフィールド
@freezed
class ObsSendMessageData with _$ObsSendMessageData {
  const factory ObsSendMessageData.request(
      {required String requestType, required String requestId}) = Request;

  const factory ObsSendMessageData.identify({required int rpcVersion}) =
      Identify;

  factory ObsSendMessageData.fromJson(Map<String, dynamic> json) =>
      _$ObsSendMessageDataFromJson(json);
}
