import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/util/current_time_provider.dart';

import '../usecase/home_on_create_use_case.dart';

class HomeEventHandler {
  final HomeOnCreateUseCase _onCreateUseCase;

  final IkutLogListStateNotifier _stateNotifier;

  final CurrentTimeGetter _currentTimeGetter;

  HomeEventHandler(
      this._onCreateUseCase, this._stateNotifier, this._currentTimeGetter);

  Future<void> onCreate() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await _onCreateUseCase.execute();
  }

  void onCameraStart() {
    _stateNotifier.onCameraStart(_currentTimeGetter.get());
  }
}

final homeEventHandlerProvider = Provider((ref) {
  return HomeEventHandler(
      ref.read(homeOnCreateUseCase),
      ref.read(ikutLogListStateNotifierProvider.notifier),
      ref.read(currentTimeGetterProvider));
});
