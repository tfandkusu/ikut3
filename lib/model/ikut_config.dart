import 'package:freezed_annotation/freezed_annotation.dart';

part 'ikut_config.freezed.dart';

@freezed
class IkutConfig with _$IkutConfig {
  const factory IkutConfig(
      {required bool saveWhenKillScene,
      required bool saveWhenDeathScene}) = _IkutConfig;
}
