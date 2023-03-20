import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/ikut_log.dart';

class IkutLogListStateNotifier extends StateNotifier<List<IkutLog>> {
  IkutLogListStateNotifier() : super([]);

  void onAppStart(DateTime dateTime) {
    state = [...state, IkutLog.appStart(dateTime: dateTime)];
  }

  void onCameraStart(DateTime dateTime) {
    state = [...state, IkutLog.cameraStart(dateTime: dateTime)];
  }

  void onSaveReplayBuffer(DateTime dateTime) {
    state = [...state, IkutLog.saveReplayBuffer(dateTime: dateTime)];
  }
}

final ikutLogListStateNotifierProvider =
    StateNotifierProvider<IkutLogListStateNotifier, List<IkutLog>>(
        (ref) => IkutLogListStateNotifier());
