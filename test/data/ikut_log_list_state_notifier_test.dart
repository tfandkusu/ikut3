import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/model/ikut_log.dart';

void main() {
  test("ikutLogListStateNotifierProvider success", () {
    final dateTime = DateTime.now();
    const path = "/Users/tfandkusu/Movie/replay.mp4";
    final container = ProviderContainer();
    final stateNotifier =
        container.read(ikutLogListStateNotifierProvider.notifier);
    getUiModel() => container.read(ikutLogListStateNotifierProvider);
    expect(getUiModel(), []);
    stateNotifier.onAppStart(dateTime.copyWith(second: 0));
    expect(getUiModel(),
        [IkutLog.appStart(dateTime: dateTime.copyWith(second: 0))]);
    stateNotifier.onStartConnect(dateTime.copyWith(second: 1));
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.connecting(dateTime: dateTime.copyWith(second: 1))
    ]);
    stateNotifier.onConnected(dateTime.copyWith(second: 2));
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.connecting(dateTime: dateTime.copyWith(second: 1)),
      IkutLog.connected(dateTime: dateTime.copyWith(second: 2)),
    ]);
    stateNotifier.onReplayBufferHasNotStarted(dateTime.copyWith(second: 3));
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.connecting(dateTime: dateTime.copyWith(second: 1)),
      IkutLog.connected(dateTime: dateTime.copyWith(second: 2)),
      IkutLog.replayBufferHasNotStarted(dateTime: dateTime.copyWith(second: 3))
    ]);
    stateNotifier.onCameraStart(dateTime.copyWith(second: 4));
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.connecting(dateTime: dateTime.copyWith(second: 1)),
      IkutLog.connected(dateTime: dateTime.copyWith(second: 2)),
      IkutLog.replayBufferHasNotStarted(dateTime: dateTime.copyWith(second: 3)),
      IkutLog.cameraStart(dateTime: dateTime.copyWith(second: 4))
    ]);
    stateNotifier.onSaveReplayBuffer(dateTime.copyWith(second: 5));
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.connecting(dateTime: dateTime.copyWith(second: 1)),
      IkutLog.connected(dateTime: dateTime.copyWith(second: 2)),
      IkutLog.replayBufferHasNotStarted(dateTime: dateTime.copyWith(second: 3)),
      IkutLog.cameraStart(dateTime: dateTime.copyWith(second: 4)),
      IkutLog.saveReplayBuffer(dateTime: dateTime.copyWith(second: 5))
    ]);
    stateNotifier.onReplayBufferSaved(dateTime.copyWith(second: 6), path);
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.connecting(dateTime: dateTime.copyWith(second: 1)),
      IkutLog.connected(dateTime: dateTime.copyWith(second: 2)),
      IkutLog.replayBufferHasNotStarted(dateTime: dateTime.copyWith(second: 3)),
      IkutLog.cameraStart(dateTime: dateTime.copyWith(second: 4)),
      IkutLog.saveReplayBuffer(dateTime: dateTime.copyWith(second: 5)),
      IkutLog.replayBufferSaved(
          dateTime: dateTime.copyWith(second: 6), path: path)
    ]);
    stateNotifier.onReplayBufferIsStarted(dateTime.copyWith(second: 7));
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.connecting(dateTime: dateTime.copyWith(second: 1)),
      IkutLog.connected(dateTime: dateTime.copyWith(second: 2)),
      IkutLog.replayBufferHasNotStarted(dateTime: dateTime.copyWith(second: 3)),
      IkutLog.cameraStart(dateTime: dateTime.copyWith(second: 4)),
      IkutLog.saveReplayBuffer(dateTime: dateTime.copyWith(second: 5)),
      IkutLog.replayBufferSaved(
          dateTime: dateTime.copyWith(second: 6), path: path),
      IkutLog.replayBufferIsStarted(dateTime: dateTime.copyWith(second: 7))
    ]);
    stateNotifier.onReplayBufferIsStopped(dateTime.copyWith(second: 8));
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.connecting(dateTime: dateTime.copyWith(second: 1)),
      IkutLog.connected(dateTime: dateTime.copyWith(second: 2)),
      IkutLog.replayBufferHasNotStarted(dateTime: dateTime.copyWith(second: 3)),
      IkutLog.cameraStart(dateTime: dateTime.copyWith(second: 4)),
      IkutLog.saveReplayBuffer(dateTime: dateTime.copyWith(second: 5)),
      IkutLog.replayBufferSaved(
          dateTime: dateTime.copyWith(second: 6), path: path),
      IkutLog.replayBufferIsStarted(dateTime: dateTime.copyWith(second: 7)),
      IkutLog.replayBufferIsStopped(dateTime: dateTime.copyWith(second: 8))
    ]);
  });
  test("ikutLogListStateNotifierProvider error", () {
    final dateTime = DateTime.now();
    final container = ProviderContainer();
    final stateNotifier =
        container.read(ikutLogListStateNotifierProvider.notifier);
    getUiModel() => container.read(ikutLogListStateNotifierProvider);
    expect(getUiModel(), []);
    stateNotifier.onAppStart(dateTime.copyWith(second: 0));
    expect(getUiModel(),
        [IkutLog.appStart(dateTime: dateTime.copyWith(second: 0))]);
    stateNotifier.onStartConnect(dateTime.copyWith(second: 1));
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.connecting(dateTime: dateTime.copyWith(second: 1))
    ]);
    stateNotifier.onConnectError(dateTime.copyWith(second: 2));
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.connecting(dateTime: dateTime.copyWith(second: 1)),
      IkutLog.connectError(dateTime: dateTime.copyWith(second: 2)),
    ]);
  });
}
