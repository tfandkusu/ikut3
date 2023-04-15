import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/ikut_log.dart';

class IkutLogListStateNotifier extends StateNotifier<List<IkutLog>> {
  IkutLogListStateNotifier() : super([]);

  IkutLogListStateNotifier.override(List<IkutLog> logList) : super(logList);

  void onAppStart(DateTime dateTime) {
    state = [...state, IkutLog.appStart(dateTime: dateTime)];
  }

  void onCameraStart(DateTime dateTime) {
    state = [...state, IkutLog.cameraStart(dateTime: dateTime)];
  }

  void onStartConnect(DateTime dateTime) {
    state = [...state, IkutLog.connecting(dateTime: dateTime)];
  }

  void onConnectError(DateTime dateTime) {
    state = [...state, IkutLog.connectError(dateTime: dateTime)];
  }

  void onConnected(DateTime dateTime) {
    state = [...state, IkutLog.connected(dateTime: dateTime)];
  }

  void onSaveReplayBuffer(DateTime dateTime) {
    state = [...state, IkutLog.saveReplayBuffer(dateTime: dateTime)];
  }

  void onReplayBufferSaved(DateTime dateTime, String path) {
    state = [
      ...state,
      IkutLog.replayBufferSaved(dateTime: dateTime, path: path)
    ];
  }

  void onReplayBufferHasNotStarted(DateTime dateTime) {
    state = [...state, IkutLog.replayBufferHasNotStarted(dateTime: dateTime)];
  }

  void onReplayBufferIsStarted(DateTime dateTime) {
    state = [...state, IkutLog.replayBufferIsStarted(dateTime: dateTime)];
  }

  void onReplayBufferIsStopped(DateTime dateTime) {
    state = [...state, IkutLog.replayBufferIsStopped(dateTime: dateTime)];
  }

  void onReplayBufferIsDisabled(DateTime dateTime) {
    state = [...state, IkutLog.replayBufferIsDisabled(dateTime: dateTime)];
  }
}

final ikutLogListStateNotifierProvider =
    StateNotifierProvider<IkutLogListStateNotifier, List<IkutLog>>(
        (ref) => IkutLogListStateNotifier());
