import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/config_repository.dart';
import 'package:ikut3/data/config_state_notifier.dart';
import 'package:ikut3/data/local_data_source.dart';
import 'package:ikut3/model/ikut_config.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockConfigStateNotifier extends Mock implements ConfigStateNotifier {}

void main() {
  final localDataSource = MockLocalDataSource();
  final configStateNotifier = MockConfigStateNotifier();
  test("configRepository", () async {
    final container = ProviderContainer(
      overrides: [
        localDataSourceProvider.overrideWithValue(localDataSource),
        configStateNotifierProvider.overrideWith((_) => configStateNotifier)
      ],
    );
    when(() => localDataSource.isSaveWhenKillScene()).thenAnswer((_) async {
      return true;
    });
    when(() => localDataSource.isSaveWhenDeathScene()).thenAnswer((_) async {
      return false;
    });
    when(() => localDataSource.setSaveWhenKillScene(false))
        .thenAnswer((_) async {});
    when(() => localDataSource.setSaveWhenDeathScene(true))
        .thenAnswer((_) async {});
    final configRepository = container.read(configRepositoryProvider);
    expect(configRepository.getConfig(),
        const IkutConfig(saveWhenKillScene: false, saveWhenDeathScene: true));
    await configRepository.load();
    expect(configRepository.getConfig(),
        const IkutConfig(saveWhenKillScene: true, saveWhenDeathScene: false));
    await configRepository.setSaveWhenKillScene(false);
    expect(configRepository.getConfig(),
        const IkutConfig(saveWhenKillScene: false, saveWhenDeathScene: false));
    await configRepository.setSaveWhenDeathScene(true);
    expect(configRepository.getConfig(),
        const IkutConfig(saveWhenKillScene: false, saveWhenDeathScene: true));
    verifyInOrder([
      () => localDataSource.isSaveWhenKillScene(),
      () => localDataSource.isSaveWhenDeathScene(),
      () => configStateNotifier.setSaveWhenKillScene(false),
      () => localDataSource.setSaveWhenKillScene(false),
      () => configStateNotifier.setSaveWhenDeathScene(true),
      () => localDataSource.setSaveWhenDeathScene(true)
    ]);
  });
}
