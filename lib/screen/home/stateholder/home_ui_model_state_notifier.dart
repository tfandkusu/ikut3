import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model.dart';

class HomeUiModelStateNotifier extends StateNotifier<HomeUiModel> {
  HomeUiModelStateNotifier() : super(const HomeUiModel(logs: []));

  void onAppStart(DateTime dateTime) {
    state = state.copyWith(
        logs: [...state.logs, HomeUiModelLog.appStart(dateTime: dateTime)]);
  }

  void onCameraStart(DateTime dateTime) {
    state = state.copyWith(
        logs: [...state.logs, HomeUiModelLog.cameraStart(dateTime: dateTime)]);
  }

  void onSaveReplayBuffer(DateTime dateTime) {
    state = state.copyWith(logs: [
      ...state.logs,
      HomeUiModelLog.saveReplayBuffer(dateTime: dateTime)
    ]);
  }
}

final homeUiModelStateNotifierProvider =
    StateNotifierProvider<HomeUiModelStateNotifier, HomeUiModel>(
        (ref) => HomeUiModelStateNotifier());
