import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_config_state_notifier.dart';
import 'package:ikut3/model/ikut_config.dart';

void main() {
  test("ikutConfigStateNotifier", () {
    final container = ProviderContainer();
    final stateNotifier =
        container.read(ikutConfigStateNotifierProvider.notifier);
    getConfig() => container.read(ikutConfigStateNotifierProvider);
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
