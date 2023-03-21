import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/ikut_log_list_state_notifier.dart';
import '../../../data/obs_repository.dart';
import '../../../util/current_time_provider.dart';
import '../../../util/prediction/predict.dart';
import '../../../util/prediction/predict_provider.dart';

class HomeOnCreateUseCase {
  final Predict _predict;

  final ObsRepository _obsRepository;

  final IkutLogListStateNotifier _stateNotifier;

  final CurrentTimeGetter _currentTimeGetter;

  Function _predictTask = () {};

  HomeOnCreateUseCase(this._predict, this._obsRepository, this._stateNotifier,
      this._currentTimeGetter);

  Future<void> execute() async {
    _stateNotifier.onAppStart(_currentTimeGetter.get());
    await _predict.load();
    _predictTask = () {
      final startTime = DateTime.now().millisecondsSinceEpoch;
      _predict.predict((count, death) {
        final endTime = DateTime.now().millisecondsSinceEpoch;
        // デスシーンでないときは0.5秒後にシーン分類する
        int baseDelayTime = 500;
        // デスシーンの時は8秒後にシーン分類を再開する。
        if (death) {
          // デスシーンの時はリプレイバッファを保存する。
          _obsRepository.saveReplayBuffer();
          _stateNotifier.onSaveReplayBuffer(_currentTimeGetter.get());
          baseDelayTime = 8000;
        }
        final delay = max(baseDelayTime - (endTime - startTime), 0).toInt();
        Future.delayed(Duration(milliseconds: delay), () {
          _predictTask();
        });
      });
    };
    _predictTask();
  }
}

final homeOnCreateUseCase = Provider((ref) {
  return HomeOnCreateUseCase(
      ref.read(predictProvider),
      ref.read(obsRepositoryProvider),
      ref.read(ikutLogListStateNotifierProvider.notifier),
      ref.read(currentTimeGetterProvider));
});
