import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../util/prediction/predict.dart';

class HomeEventHandler {

  final Predict _predict;

  Function _predictTask = (){};

  HomeEventHandler(this._predict);

  Future<void> onCreate() async {
    await _predict.load();
    _predictTask = () {
      final startTime = DateTime.now().millisecondsSinceEpoch;
      _predict.predict((count, death) {
        final endTime = DateTime.now().millisecondsSinceEpoch;
        // デスシーンでないときは0.5秒後にシーン分類する
        int baseDelayTime = 500;
        // デスシーンの時は8秒後にシーン分類を再開する。
        if(death) {
          baseDelayTime = 8000;
        }
        final delay = max(baseDelayTime - (endTime - startTime), 0).toInt();
        Future.delayed(Duration(milliseconds: delay), (){
          _predictTask();
        });
      });
    };
    _predictTask();
  }
}

final homeEventHandlerProvider = Provider((ref){
  return HomeEventHandler(ref.read(predictProvider));
});
