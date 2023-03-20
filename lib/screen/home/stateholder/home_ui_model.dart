import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_ui_model.freezed.dart';

/// ホーム画面の状態
@freezed
class HomeUiModel with _$HomeUiModel {
  const factory HomeUiModel({required List<HomeUiModelLog> logs}) =
      _HomeUiModel;
}

@freezed
class HomeUiModelLog with _$HomeUiModelLog {
  const factory HomeUiModelLog.appStart({required DateTime dateTime}) =
      AppStart;
}
