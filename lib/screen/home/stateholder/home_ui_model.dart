import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_ui_model.freezed.dart';

/// ホーム画面の状態
@freezed
class HomeUiModel with _$HomeUiModel {
  const factory HomeUiModel({required List<HomeUiModelLog> logs}) =
      _HomeUiModel;
}

@freezed
class HomeUiModelLog with _$HomeUiModelLog {
  const factory HomeUiModelLog.appStart({required DateTime dateTime}) =
      AppStart;

  const factory HomeUiModelLog.cameraStart({required DateTime dateTime}) =
      CameraStart;

  const factory HomeUiModelLog.saveReplayBuffer({required DateTime dateTime}) =
      SaveReplayBuffer;

  const factory HomeUiModelLog.replayBufferSaved(
      {required DateTime dateTime,
      required String uriString}) = ReplayBufferSaved;
}
