import 'package:freezed_annotation/freezed_annotation.dart';

part 'ikut_config.freezed.dart';

/// ユーザ設定
@freezed
class IkutConfig with _$IkutConfig {
  /// [saveWhenKillScene] たおしたシーンのときにリプレイバッファを保存するか
  /// [saveWhenDeathScene] やられたシーンのときにリプレイバッファを保存するか
  /// [deathSceneSaveDelay] やられたシーンのときにリプレイバッファを保存するまでの遅延時間
  const factory IkutConfig(
      {required bool saveWhenKillScene,
      required bool saveWhenDeathScene,
      required double deathSceneSaveDelay}) = _IkutConfig;
}
