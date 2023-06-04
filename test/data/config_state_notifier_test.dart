import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/config_state_notifier.dart';
import 'package:ikut3/model/ikut_config.dart';

void main() {
  test("configStateNotifier", () {
    final container = ProviderContainer();
    final stateNotifier = container.read(configStateNotifierProvider.notifier);
    getConfig() => container.read(configStateNotifierProvider);
    expect(getConfig(),
        const IkutConfig(saveWhenKillScene: false, saveWhenDeathScene: true));
    stateNotifier.setSaveWhenKillScene(true);
    expect(getConfig(),
        const IkutConfig(saveWhenKillScene: true, saveWhenDeathScene: true));
    stateNotifier.setSaveWhenDeathScene(false);
    expect(getConfig(),
        const IkutConfig(saveWhenKillScene: true, saveWhenDeathScene: false));
  });
}
