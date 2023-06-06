/// 動画フレーム予測ラベル
enum PredictLabel {
  // たおした
  kill,
  // やられた
  death,
  // その他
  other
}

class Predict {
  Future<void> load() async {}

  void predict(void Function(int count, PredictLabel label) onResult) {}
}
