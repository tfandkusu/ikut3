import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/local_data_source.dart';
import 'package:ikut3/model/ikut_config.dart';

import 'config_state_notifier.dart';

/// ユーザの設定に関して、整合性を担保しつつ読み書きを行う担当クラス。
/// 更新監視を行う場合は、[ConfigStateNotifier]を利用すること。
class ConfigRepository {
  final LocalDataSource _localDataSource;

  final ConfigStateNotifier _configStateNotifier;

  static const defaultSaveWhenKillScene =
      LocalDataSource.defaultSaveWhenKillScene;

  static const defaultSaveWhenDeathScene =
      LocalDataSource.defaultSaveWhenDeathScene;

  static const defaultHost = LocalDataSource.defaultHost;

  static const defaultPort = LocalDataSource.defaultPort;

  ConfigRepository(this._localDataSource, this._configStateNotifier);

  IkutConfig _config = const IkutConfig(
      saveWhenKillScene: defaultSaveWhenKillScene,
      saveWhenDeathScene: defaultSaveWhenDeathScene);

  /// アプリ起動時の設定読み込み
  Future<void> load() async {
    final saveWhenKillScene = await _localDataSource.isSaveWhenKillScene();
    final saveWhenDeathScene = await _localDataSource.isSaveWhenDeathScene();
    _config = IkutConfig(
        saveWhenKillScene: saveWhenKillScene,
        saveWhenDeathScene: saveWhenDeathScene);
    _configStateNotifier.setSaveWhenKillScene(saveWhenKillScene);
    _configStateNotifier.setSaveWhenDeathScene(saveWhenDeathScene);
  }

  /// 現在の設定を取得する。
  /// UI でなく、画像認識部分で使用する
  IkutConfig getConfig() {
    return _config;
  }

  Future<void> setSaveWhenKillScene(bool saveWhenKillScene) async {
    _configStateNotifier.setSaveWhenKillScene(saveWhenKillScene);
    _config = _config.copyWith(saveWhenKillScene: saveWhenKillScene);
    await _localDataSource.setSaveWhenKillScene(saveWhenKillScene);
  }

  Future<void> setSaveWhenDeathScene(bool saveWhenDeathScene) async {
    _configStateNotifier.setSaveWhenDeathScene(saveWhenDeathScene);
    _config = _config.copyWith(saveWhenDeathScene: saveWhenDeathScene);
    await _localDataSource.setSaveWhenDeathScene(saveWhenDeathScene);
  }
}

final configRepositoryProvider = Provider<ConfigRepository>((ref) =>
    ConfigRepository(ref.read(localDataSourceProvider),
        ref.read(configStateNotifierProvider.notifier)));
