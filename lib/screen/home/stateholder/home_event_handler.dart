import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/obs_repository.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_state_notifier.dart';
import 'package:ikut3/util/current_time_provider.dart';

import '../../../util/prediction/predict.dart';
import '../../../util/prediction/predict_provider.dart';

class HomeEventHandler {
  final Predict _predict;

  final ObsRepository _obsRepository;

  final HomeUiModelStateNotifier _stateNotifier;

  final CurrentTimeGetter _currentTimeGetter;

  Function _predictTask = () {};

  HomeEventHandler(this._predict, this._obsRepository, this._stateNotifier,
      this._currentTimeGetter);

  Future<void> onCreate() async {
    await Future.delayed(const Duration(milliseconds: 100));
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

  void onCameraStart() {
    _stateNotifier.onCameraStart(_currentTimeGetter.get());
  }
}

final homeEventHandlerProvider = Provider((ref) {
  return HomeEventHandler(
      ref.read(predictProvider),
      ref.read(obsRepositoryProvider),
      ref.read(homeUiModelStateNotifierProvider.notifier),
      ref.read(currentTimeGetterProvider));
});
