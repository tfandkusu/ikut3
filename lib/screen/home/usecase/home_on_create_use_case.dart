import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/config_repository.dart';

import '../../../data/ikut_log_list_state_notifier.dart';
import '../../../data/obs_repository.dart';
import '../../../util/current_time_provider.dart';
import '../../../util/prediction/predict.dart';
import '../../../util/prediction/predict_provider.dart';

class HomeOnCreateUseCase {
  final Predict _predict;

  final ObsRepository _obsRepository;

  final ConfigRepository _configRepository;

  final IkutLogListStateNotifier _stateNotifier;

  final CurrentTimeGetter _currentTimeGetter;

  /// 画像認識1回分のタスク
  Function _predictTask = () {};

  HomeOnCreateUseCase(this._predict, this._obsRepository,
      this._configRepository, this._stateNotifier, this._currentTimeGetter);

  // たおしたシーン中フラグ
  bool _killScene = false;

  // リプレイバッファ保存ペンディングミリ秒
  int _saveDelayTime = 0;

  Future<void> execute() async {
    await _predict.load();
    _predictTask = () {
      _runPredict();
    };
    _predictTask();
  }

  void _runPredict() {
    final startTime = DateTime.now().millisecondsSinceEpoch;
    _predict.predict((count, label) {
      final endTime = DateTime.now().millisecondsSinceEpoch;
      _onPredict(startTime, endTime, label);
    });
  }

  void _onPredict(int startTime, int endTime, PredictLabel label) {
    // 基本は0.5秒後にシーン分類する
    int delayTime = 500;
    if (_obsRepository.isConnected()) {
      final currentTime = _currentTimeGetter.get();
      final config = _configRepository.getConfig();
      if (_saveDelayTime > 0) {
        // 予約されていた保存タスクを実行する
        _obsRepository.saveReplayBuffer();
        _stateNotifier.onSaveReplayBuffer(currentTime);
        _saveDelayTime = 0;
        // やられたシーンあとは8秒後にシーン分類を再開する。
        // 遅延分は引く。
        delayTime = 8000 - _saveDelayTime;
      } else {
        switch (label) {
          case PredictLabel.kill:
            if (!_killScene && config.saveWhenKillScene) {
              _stateNotifier.onKillScene(currentTime);
            }
            _killScene = true;
            break;
          case PredictLabel.death:
            // やられたシーンを保存するケース
            if (config.saveWhenDeathScene) {
              _stateNotifier.onDeathScene(
                  currentTime, config.deathSceneSaveDelay);
              if (config.deathSceneSaveDelay > 0) {
                // やられたシーンの保存はN秒後に行う。
                _saveDelayTime = (config.deathSceneSaveDelay * 1000) as int;
                delayTime = _saveDelayTime;
              }
            }
            // 「○○をたおした」表示中の「やられた」でもリプレイバッファを保存する。
            if ((_killScene && config.saveWhenKillScene) ||
                (config.saveWhenDeathScene && _saveDelayTime == 0)) {
              _obsRepository.saveReplayBuffer();
              _stateNotifier.onSaveReplayBuffer(currentTime);
              // やられたシーンあとは8秒後にシーン分類を再開する。
              delayTime = 8000;
            }
            _killScene = false;
            break;
          case PredictLabel.other:
            // 「○○をたおした」が消えたタイミングでリプレイバッファを保存する。
            if (_killScene && config.saveWhenKillScene) {
              _obsRepository.saveReplayBuffer();
              _stateNotifier.onSaveReplayBuffer(currentTime);
              // 次のリプレイバッファ保存まで3秒置く
              delayTime = 3000;
            }
            _killScene = false;
            break;
        }
      }
    } else {
      _killScene = false;
      _saveDelayTime = 0;
    }
    final delay = max(delayTime - (endTime - startTime), 0).toInt();
    Future.delayed(Duration(milliseconds: delay), () {
      _predictTask();
    });
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
