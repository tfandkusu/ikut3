import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/model/ikut_log.dart';

void main() {
  test("ikutLogListStateNotifierProvider", () {
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
    stateNotifier.onCameraStart(dateTime.copyWith(second: 1));
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.cameraStart(dateTime: dateTime.copyWith(second: 1))
    ]);
    stateNotifier.onSaveReplayBuffer(dateTime.copyWith(second: 2));
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.cameraStart(dateTime: dateTime.copyWith(second: 1)),
      IkutLog.saveReplayBuffer(dateTime: dateTime.copyWith(second: 2))
    ]);
    stateNotifier.onReplayBufferSaved(dateTime.copyWith(second: 3), path);
    expect(getUiModel(), [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.cameraStart(dateTime: dateTime.copyWith(second: 1)),
      IkutLog.saveReplayBuffer(dateTime: dateTime.copyWith(second: 2)),
      IkutLog.replayBufferSaved(
          dateTime: dateTime.copyWith(second: 3), path: path)
    ]);
  });
}
