import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/local_data_source.dart';

import '../model/ikut_config.dart';

class ConfigStateNotifier extends StateNotifier<IkutConfig> {
  ConfigStateNotifier()
      : super(const IkutConfig(
          saveWhenKillScene: LocalDataSource.defaultSaveWhenKillScene,
          saveWhenDeathScene: LocalDataSource.defaultSaveWhenDeathScene,
        ));

  ConfigStateNotifier.override(IkutConfig config) : super(config);

  void setSaveWhenKillScene(bool saveWhenKillScene) {
    state = state.copyWith(saveWhenKillScene: saveWhenKillScene);
  }

  void setSaveWhenDeathScene(bool saveWhenDeathScene) {
    state = state.copyWith(saveWhenDeathScene: saveWhenDeathScene);
  }
}

final configStateNotifierProvider =
    StateNotifierProvider<ConfigStateNotifier, IkutConfig>(
        (ref) => ConfigStateNotifier());
