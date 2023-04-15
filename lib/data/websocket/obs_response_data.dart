import 'package:freezed_annotation/freezed_annotation.dart';
part 'obs_response_data.freezed.dart';
part 'obs_response_data.g.dart';

@freezed
class ObsResponseData with _$ObsResponseData {
  const factory ObsResponseData({bool? outputActive}) = _ObsResponseData;

  factory ObsResponseData.fromJson(Map<String, dynamic> json) =>
      _$ObsResponseDataFromJson(json);
}
