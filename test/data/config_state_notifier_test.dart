import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/config_state_notifier.dart';
import 'package:ikut3/model/ikut_config.dart';

void main() {
  test("configStateNotifier", () {
    final container = ProviderContainer();
    final stateNotifier = container.read(configStateNotifierProvider.notifier);
    getConfig() => container.read(configStateNotifierProvider);
    expect(
        getConfig(),
        const IkutConfig(
            saveWhenKillScene: false,
            saveWhenDeathScene: true,
            deathSceneSaveDelay: 0.0));
    stateNotifier.setSaveWhenKillScene(true);
    expect(
        getConfig(),
        const IkutConfig(
            saveWhenKillScene: true,
            saveWhenDeathScene: true,
            deathSceneSaveDelay: 0.0));
    stateNotifier.setSaveWhenDeathScene(false);
    expect(
        getConfig(),
        const IkutConfig(
            saveWhenKillScene: true,
            saveWhenDeathScene: false,
            deathSceneSaveDelay: 0.0));
    stateNotifier.setDeathSceneSaveDelay(4.0);
    expect(
        getConfig(),
        const IkutConfig(
            saveWhenKillScene: true,
            saveWhenDeathScene: false,
            deathSceneSaveDelay: 4.0));
  });
}
