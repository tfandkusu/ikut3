import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/ikut_log.dart';

part 'home_ui_model.freezed.dart';

/// ホーム画面の状態
@freezed
class HomeUiModel with _$HomeUiModel {
  /// [logs] ログ一覧
  /// [isShowVideo] video要素を表示する
  const factory HomeUiModel(
      {required List<IkutLog> logs, required bool isShowVideo}) = _HomeUiModel;
}
