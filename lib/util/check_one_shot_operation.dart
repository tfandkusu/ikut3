/// ワンショットオペレーションを発動するか否かを
/// Riverpodのref.listenメソッドのコールバックでチェックする
///
/// [previous] 前の状態
/// [next] 現在の状態
/// [getValue] 現在の状態から、ワンショットオペレーション対象の値を得る
/// [runOperation]  ワンショットオペレーションを実行する場合は、このコールバックが呼ばれる
void checkOneShotOperation<S, V>(S? previous, S next, V? Function(S) getValue,
    void Function(V) runOperation) {
  // 前の状態から、ワンショットオペレーション対象の値が変化して
  if (previous == null || getValue(previous) != getValue(next)) {
    final value = getValue(next);
    if (value != null) {
      // その値がnullでないときはコールバックを呼ぶ
      runOperation(value);
    }
  }
}
