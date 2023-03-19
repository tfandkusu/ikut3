// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';
import 'dart:js_util';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/screen/home/widget/video_element.dart';
import 'package:ikut3/util/prediction/predict_js.dart';

class Predict {

  /// 分類対象画像の横幅
  static const _width = 398;

  /// 分類対象画像の縦幅
  static const _height = 224;

  /// canvas要素
  final _canvasElement = CanvasElement(width: _width, height: _height);

  /// フレームカウント
  int _count = 1;

  /// 1: モデルを読み込む
  Future<void> load() async {
    await promiseToFuture(loadImageClassification());
  }

  /// 現在の取り込みフレームを画像分類する。
  void predict(void Function(int count, bool death) onResult) {
    final videoElement = getVideoElement();
    // フレームをcanvasに書き込む
    final context = _canvasElement.context2D;
    context.drawImageScaled(
        videoElement, 0, 0, _width, _height);
    // canvasをimgタグに書き出す
    final dataUrl = _canvasElement.toDataUrl();
    final imageElement = ImageElement();
    imageElement.addEventListener("load", (event) async {
      // imgタグでの読込が完了したら予測する
      String jsonString = await promiseToFuture(classify(imageElement));
      // フレームの予測が完了
      final label = _getLabel(jsonString);
      onResult(_count, label == "death");
      ++_count;
    });
    imageElement.src = dataUrl;
  }

  /// 結果JSONからラベル名を取得する
  /// [jsonString] 結果JSON
  String _getLabel(String jsonString) {
    List<dynamic> dynamicClasses = jsonDecode(jsonString);
    Map<String, double> classes = {};
    for (var e in dynamicClasses) {
      classes[e['label']] = e['prob'];
    }
    String maxLabel = "";
    double maxProb = -1.0;
    classes.forEach((label, prob) {
      if (prob > maxProb) {
        maxLabel = label;
        maxProb = prob;
      }
    });
    return maxLabel;
  }
}

final predictProvider = Provider((ref) {
  return Predict();
});
