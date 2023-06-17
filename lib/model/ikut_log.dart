import 'package:freezed_annotation/freezed_annotation.dart';

part 'ikut_log.freezed.dart';

@freezed
class IkutLog with _$IkutLog {
  /// 起動しました。
  const factory IkutLog.appStart({required DateTime dateTime}) = AppStart;

  /// カメラの取り込みを開始しました。
  const factory IkutLog.cameraStart({required DateTime dateTime}) = CameraStart;

  /// たおしたシーンを検出
  const factory IkutLog.killScene({required DateTime dateTime}) = KillScene;

  /// やられたシーンを検出
  const factory IkutLog.deathScene(
      {required DateTime dateTime, required double saveDelay}) = DeathScene;

  /// OBSにリプレイバッファ保存を要求しました。
  const factory IkutLog.saveReplayBuffer({required DateTime dateTime}) =
      SaveReplayBuffer;

  /// 保存完了
  const factory IkutLog.replayBufferSaved(
      {required DateTime dateTime, required String path}) = ReplayBufferSaved;

  /// WebSocket接続中
  const factory IkutLog.connecting({required DateTime dateTime}) = Connecting;

  /// WebSocket接続完了
  const factory IkutLog.connected({required DateTime dateTime}) = Connected;

  /// WebSocket接続失敗
  const factory IkutLog.connectError({required DateTime dateTime}) =
      ConnectError;

  /// リプレイバッファが開始されていません。
  const factory IkutLog.replayBufferHasNotStarted(
      {required DateTime dateTime}) = ReplayBufferHasNotStarted;

  /// リプレイバッファが開始しました。
  const factory IkutLog.replayBufferIsStarted({required DateTime dateTime}) =
      ReplayBufferIsStarted;

  /// リプレイバッファが停止しました。
  const factory IkutLog.replayBufferIsStopped({required DateTime dateTime}) =
      ReplayBufferIsStopped;

  /// リプレイバッファが有効になっていません。
  const factory IkutLog.replayBufferIsDisabled({required DateTime dateTime}) =
      ReplayBufferIsDisabled;
}
