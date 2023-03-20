import 'package:freezed_annotation/freezed_annotation.dart';

part 'ikut_log.freezed.dart';

@freezed
class IkutLog with _$IkutLog {
  const factory IkutLog.appStart({required DateTime dateTime}) = AppStart;

  const factory IkutLog.cameraStart({required DateTime dateTime}) = CameraStart;

  const factory IkutLog.saveReplayBuffer({required DateTime dateTime}) =
      SaveReplayBuffer;

  const factory IkutLog.replayBufferSaved(
      {required DateTime dateTime, required String path}) = ReplayBufferSaved;
}
