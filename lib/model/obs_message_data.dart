import 'package:freezed_annotation/freezed_annotation.dart';
part 'obs_message_data.freezed.dart';
part 'obs_message_data.g.dart';

/// OBSとやりとりするためのメッセージのdフィールド
@freezed
class ObsMessageData with _$ObsMessageData {
  const factory ObsMessageData.request(
      {required String requestType, required String requestId}) = Request;

  const factory ObsMessageData.identify({required int rpcVersion}) = Identify;

  factory ObsMessageData.fromJson(Map<String, dynamic> json) =>
      _$ObsMessageDataFromJson(json);
}
