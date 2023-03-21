import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_state_notifier.dart';
import 'package:ikut3/util/current_time_provider.dart';

import '../usecase/home_on_create_use_case.dart';

class HomeEventHandler {
  final HomeOnCreateUseCase _onCreateUseCase;

  final IkutLogListStateNotifier _ikutLogStateNotifier;

  final CurrentTimeGetter _currentTimeGetter;

  final HomeUiModelStateNotifier _stateNotifier;

  HomeEventHandler(this._onCreateUseCase, this._ikutLogStateNotifier,
      this._currentTimeGetter, this._stateNotifier);

  Future<void> onCreate() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await _onCreateUseCase.execute();
  }

  void onCameraStart() {
    _ikutLogStateNotifier.onCameraStart(_currentTimeGetter.get());
  }

  void connectCamera() {
    _stateNotifier.onConnectCamera();
  }
}

final homeEventHandlerProvider = Provider((ref) {
  return HomeEventHandler(
      ref.read(homeOnCreateUseCase),
      ref.read(ikutLogListStateNotifierProvider.notifier),
      ref.read(currentTimeGetterProvider),
      ref.read(homeUiModelStateNotifierProvider.notifier));
});
