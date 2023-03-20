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

  void onSaveReplayBuffer(DateTime dateTime) {
    state = [...state, IkutLog.saveReplayBuffer(dateTime: dateTime)];
  }

  void onReplayBufferSaved(DateTime dateTime, String path) {
    state = [
      ...state,
      IkutLog.replayBufferSaved(dateTime: dateTime, path: path)
    ];
  }
}

final ikutLogListStateNotifierProvider =
    StateNotifierProvider<IkutLogListStateNotifier, List<IkutLog>>(
        (ref) => IkutLogListStateNotifier());
