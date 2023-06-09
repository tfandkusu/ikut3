import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/config_repository.dart';

import '../../../data/ikut_log_list_state_notifier.dart';
import '../../../data/obs_repository.dart';
import '../../../model/ikut_scene.dart';
import '../../../util/current_time_provider.dart';
import '../../../util/prediction/predict.dart';
import '../../../util/prediction/predict_provider.dart';

class HomeOnCreateUseCase {
  final Predict _predict;

  final ObsRepository _obsRepository;

  final ConfigRepository _configRepository;

  final IkutLogListStateNotifier _stateNotifier;

  final CurrentTimeGetter _currentTimeGetter;

  Function _predictTask = () {};

  HomeOnCreateUseCase(this._predict, this._obsRepository,
      this._configRepository, this._stateNotifier, this._currentTimeGetter);

  // たおしたシーン中フラグ
  bool _killScene = false;

  Future<void> execute() async {
    await _predict.load();
    _predictTask = () {
      final startTime = DateTime.now().millisecondsSinceEpoch;
      _predict.predict((count, label) {
        final endTime = DateTime.now().millisecondsSinceEpoch;
        // デスシーンでないときは0.5秒後にシーン分類する
        int baseDelayTime = 500;
        if (_obsRepository.isConnected()) {
          final currentTime = _currentTimeGetter.get();
          final config = _configRepository.getConfig();
          switch (label) {
            case PredictLabel.kill:
              if (!_killScene && config.saveWhenKillScene) {
                _stateNotifier.onScene(currentTime, IkutScene.kill);
              }
              _killScene = true;
              break;
            case PredictLabel.death:
              // やられたシーンを保存するケース
              if (config.saveWhenDeathScene) {
                _stateNotifier.onScene(currentTime, IkutScene.death);
              }
              // 「○○をたおした」表示中の「やられた」でもリプレイバッファを保存する。
              if ((_killScene && config.saveWhenKillScene) ||
                  config.saveWhenDeathScene) {
                _obsRepository.saveReplayBuffer();
                _stateNotifier.onSaveReplayBuffer(currentTime);
              }
              _killScene = false;
              // やられたシーンあとは8秒後にシーン分類を再開する。
              baseDelayTime = 8000;
              break;
            case PredictLabel.other:
              // 「○○をたおした」が消えたタイミングでリプレイバッファを保存する。
              if (_killScene && config.saveWhenKillScene) {
                _obsRepository.saveReplayBuffer();
                _stateNotifier.onSaveReplayBuffer(currentTime);
                baseDelayTime = 3000;
              }
              _killScene = false;
              break;
          }
        } else {
          _killScene = false;
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
      ref.read(configRepositoryProvider),
      ref.read(ikutLogListStateNotifierProvider.notifier),
      ref.read(currentTimeGetterProvider));
});
