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

/// WebSocket接続の状態
enum HomeConnectStatus {
  /// 未接続または接続中
  progress,

  /// 接続完了
  success,

  /// エラー
  error
}

/// ホーム画面の状態
@freezed
class HomeUiModel with _$HomeUiModel {
  /// [logs] ログ一覧
  /// [videoStatus] ビデオ部分になにを表示するか
  /// [connection] obs-websocket 接続情報
  /// [connectStatus] obs-websocket 接続状態
  const factory HomeUiModel(
      {required List<IkutLog> logs,
      required HomeVideoStatus videoStatus,
      required WebSocketConnection connection,
      required HomeConnectStatus connectStatus}) = _HomeUiModel;
}
