import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/obs_repository.dart';

import '../../../util/prediction/predict.dart';

class HomeEventHandler {
  final Predict _predict;

  final ObsRepository _obsRepository;

  Function _predictTask = () {};

  HomeEventHandler(this._predict, this._obsRepository);

  Future<void> onCreate() async {
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

final homeEventHandlerProvider = Provider((ref) {
  return HomeEventHandler(
      ref.read(predictProvider), ref.read(obsRepositoryProvider));
});
