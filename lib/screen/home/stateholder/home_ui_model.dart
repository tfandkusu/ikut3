import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ikut3/model/web_socket_connection.dart';

import '../../../model/ikut_log.dart';

part 'home_ui_model.freezed.dart';

/// ビデオ部分の表示
enum HomeVideoStatus {
  /// 初期状態
  initial,

  /// 接続中
  connecting,

  /// 開始済み
  start
}

/// ホーム画面の状態
@freezed
class HomeUiModel with _$HomeUiModel {
  /// [logs] ログ一覧
  /// [videoStatus] ビデオ部分になにを表示するか
  const factory HomeUiModel(
      {required List<IkutLog> logs,
      required HomeVideoStatus videoStatus,
      required WebSocketConnection connection}) = _HomeUiModel;
}
