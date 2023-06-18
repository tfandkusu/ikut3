import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/config_repository.dart';
import 'package:ikut3/data/config_state_notifier.dart';
import 'package:ikut3/data/connection_repository.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/data/web_socket_connection_state_notifier.dart';
import 'package:ikut3/screen/home/stateholder/home_event_handler.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_state_notifier.dart';
import 'package:ikut3/screen/home/usecase/home_on_create_use_case.dart';
import 'package:ikut3/util/current_time_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeOnCreateUseCase extends Mock implements HomeOnCreateUseCase {}

class MockIkutLogListStateNotifier extends Mock
    implements IkutLogListStateNotifier {}

class MockCurrentTimeGetter extends Mock implements CurrentTimeGetter {}

class MockHomeUiModelStateNotifier extends Mock
    implements HomeUiModelStateNotifier {}

class MockConnectionRepository extends Mock implements ConnectionRepository {}

class MockConfigRepository extends Mock implements ConfigRepository {}

class MockConfigStateNotifier extends Mock implements ConfigStateNotifier {}

class MockWebSocketConnectionStateNotifier extends Mock
    implements WebSocketConnectionStateNotifier {}

void main() {
  final onCreateUseCase = MockHomeOnCreateUseCase();
  final logListStateNotifier = MockIkutLogListStateNotifier();
  final currentTimeGetter = MockCurrentTimeGetter();
  final homeUiModelStateNotifier = MockHomeUiModelStateNotifier();
  final connectionRepository = MockConnectionRepository();
  final configRepository = MockConfigRepository();
  final ikutConfigStateNotifier = MockConfigStateNotifier();
  final webSocketConnectionStateNotifier = WebSocketConnectionStateNotifier();
  test(
      'HomeEventHandler#onCreate カメラの許可をまだ出していない。obs-websocketに自動接続しない。',
          () async {
        final now = DateTime.now();
        when(() => currentTimeGetter.get()).thenReturn(now);
        when(() => configRepository.load()).thenAnswer((_) async {});
        when(() => connectionRepository.isCameraHasStarted()).thenAnswer((
            _) async {
          return false;
        });
        when(() => connectionRepository.isConnected()).thenAnswer((_) async {
          return false;
        });
        when(() => onCreateUseCase.execute()).thenAnswer((_) async {});
        final container = ProviderContainer(overrides: [
          currentTimeGetterProvider.overrideWithValue(currentTimeGetter),
          ikutLogListStateNotifierProvider
              .overrideWith((ref) => logListStateNotifier),
          homeOnCreateUseCase.overrideWithValue(onCreateUseCase),
          configRepositoryProvider.overrideWithValue(configRepository),
          connectionRepositoryProvider.overrideWithValue(connectionRepository),
          configStateNotifierProvider
              .overrideWith((ref) => ikutConfigStateNotifier),
        ]);
        final eventHandler = container.read(homeEventHandlerProvider);
        await eventHandler.onCreate();
        verifyInOrder([
              () => logListStateNotifier.onAppStart(now),
              () => configRepository.load(),
              () => connectionRepository.isCameraHasStarted(),
              () => connectionRepository.isConnected(),
              () => onCreateUseCase.execute()
        ]);
      });
  test(
      'HomeEventHandler#onCreate カメラの許可を以前の起動時に行っている。obs-websocketに自動接続する。',
          () async {
        final now = DateTime.now();
        when(() => configRepository.load()).thenAnswer((_) async {});
        when(() => connectionRepository.isCameraHasStarted()).thenAnswer((
            _) async {
          return true;
        });
        when(() => connectionRepository.isConnected()).thenAnswer((_) async {
          return true;
        });
        when(() => onCreateUseCase.execute()).thenAnswer((_) async {});
        when(() => currentTimeGetter.get()).thenReturn(now);
        final container = ProviderContainer(overrides: [
          homeOnCreateUseCase.overrideWithValue(onCreateUseCase),
          homeUiModelStateNotifierProvider
              .overrideWith((ref) => homeUiModelStateNotifier),
          configRepositoryProvider.overrideWithValue(configRepository),
          connectionRepositoryProvider.overrideWithValue(connectionRepository),
          configStateNotifierProvider
              .overrideWith((ref) => ikutConfigStateNotifier),
          ikutLogListStateNotifierProvider
              .overrideWith((ref) => logListStateNotifier),
          webSocketConnectionStateNotifierProvider
              .overrideWith((ref) => webSocketConnectionStateNotifier),
          currentTimeGetterProvider.overrideWithValue(currentTimeGetter)
        ]);
        final eventHandler = container.read(homeEventHandlerProvider);
        await eventHandler.onCreate();
        verifyInOrder([
              () => logListStateNotifier.onAppStart(now),
              () => configRepository.load(),
              () => connectionRepository.isCameraHasStarted(),
              () => homeUiModelStateNotifier.onConnectingCamera(),
              () => connectionRepository.isConnected(),
              () => logListStateNotifier.onStartConnect(now),
              () => webSocketConnectionStateNotifier.setConnect(true),
              () => onCreateUseCase.execute()
        ]);
      });
  test('HomeEventHandler#onCameraStart', () async {
    final now = DateTime.now();
    when(() => connectionRepository.setCameraHasStarted(true))
        .thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      ikutLogListStateNotifierProvider
          .overrideWith((ref) => logListStateNotifier),
      currentTimeGetterProvider.overrideWithValue(currentTimeGetter),
      homeUiModelStateNotifierProvider
          .overrideWith((ref) => homeUiModelStateNotifier),
      connectionRepositoryProvider.overrideWithValue(connectionRepository)
    ]);
    when(() => currentTimeGetter.get()).thenReturn(now);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onCameraStart();
    verifyInOrder([
          () => homeUiModelStateNotifier.onCameraStart(),
          () => currentTimeGetter.get(),
          () => logListStateNotifier.onCameraStart(now),
          () => connectionRepository.setCameraHasStarted(true),
    ]);
  });
  test('HomeEventHandler#onClickConnectCamera', () async {
    final now = DateTime.now();
    final container = ProviderContainer(overrides: [
      homeUiModelStateNotifierProvider
          .overrideWith((ref) => homeUiModelStateNotifier),
    ]);
    when(() => currentTimeGetter.get()).thenReturn(now);
    final eventHandler = container.read(homeEventHandlerProvider);
    eventHandler.onClickConnectCamera();
    verifyInOrder([() => homeUiModelStateNotifier.onConnectingCamera()]);
  });

  test('HomeEventHandler#onClickConnect', () {
    final now = DateTime.now();
    final container = ProviderContainer(overrides: [
      currentTimeGetterProvider.overrideWithValue(currentTimeGetter),
      ikutLogListStateNotifierProvider
          .overrideWith((ref) => logListStateNotifier),
      webSocketConnectionStateNotifierProvider
          .overrideWith((ref) => webSocketConnectionStateNotifier),
    ]);
    when(() => currentTimeGetter.get()).thenReturn(now);
    final eventHandler = container.read(homeEventHandlerProvider);
    eventHandler.onClickConnect();
    verifyInOrder([
          () => logListStateNotifier.onStartConnect(now),
          () => webSocketConnectionStateNotifier.setConnect(true)
    ]);
  });

  test('HomeEventHandler#onConnected', () async {
    when(() => connectionRepository.setConnected(true))
        .thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      homeUiModelStateNotifierProvider
          .overrideWith((ref) => homeUiModelStateNotifier),
      connectionRepositoryProvider.overrideWithValue(connectionRepository)
    ]);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onConnected();
    verifyInOrder([
          () => homeUiModelStateNotifier.onConnected(),
          () => connectionRepository.setConnected(true)
    ]);
  });

  test('HomeEventHandler#onConnectError', () async {
    when(() => connectionRepository.setConnected(false))
        .thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      currentTimeGetterProvider.overrideWithValue(currentTimeGetter),
      ikutLogListStateNotifierProvider
          .overrideWith((ref) => logListStateNotifier),
      homeUiModelStateNotifierProvider
          .overrideWith((ref) => homeUiModelStateNotifier),
      connectionRepositoryProvider.overrideWithValue(connectionRepository)
    ]);
    final now = DateTime.now();
    when(() => currentTimeGetter.get()).thenReturn(now);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onConnectError();
    verifyInOrder([
          () => currentTimeGetter.get(),
          () => logListStateNotifier.onConnectError(now),
          () => homeUiModelStateNotifier.onConnectError(),
          () => connectionRepository.setConnected(false)
    ]);
  });

  test('HomeEventHandler#resetConnectStatus', () {
    final container = ProviderContainer(overrides: [
      webSocketConnectionStateNotifierProvider
          .overrideWith((ref) => webSocketConnectionStateNotifier),
      homeUiModelStateNotifierProvider
          .overrideWith((ref) => homeUiModelStateNotifier)
    ]);
    final eventHandler = container.read(homeEventHandlerProvider);
    eventHandler.onConnectErrorConfirmed();
    verifyInOrder([
          () => webSocketConnectionStateNotifier.setConnect(false),
          () => homeUiModelStateNotifier.resetConnectStatus()
    ]);
  });

  test('HomeEventHandler#onChangeSaveWhenKillScene', () async {
    when(() => configRepository.setSaveWhenKillScene(true))
        .thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      configStateNotifierProvider
          .overrideWith((ref) => ikutConfigStateNotifier),
      configRepositoryProvider.overrideWithValue(configRepository),
    ]);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onChangeSaveWhenKillScene(true);
    verifyInOrder([
          () => configRepository.setSaveWhenKillScene(true),
    ]);
  });

  test('HomeEventHandler#onChangeSaveWhenDeathScene', () async {
    when(() => configRepository.setSaveWhenDeathScene(true))
        .thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      configStateNotifierProvider
          .overrideWith((ref) => ikutConfigStateNotifier),
      configRepositoryProvider.overrideWithValue(configRepository),
    ]);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onChangeSaveWhenDeathScene(true);
    verifyInOrder([() => configRepository.setSaveWhenDeathScene(true)]);
  });

  test('HomeEventHandler#onChangeDeathSceneSaveDelay', () async {
    when(() => configRepository.setDeathSceneSaveDelay(4.0))
        .thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      configStateNotifierProvider
          .overrideWith((ref) => ikutConfigStateNotifier),
      configRepositoryProvider.overrideWithValue(configRepository),
    ]);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onChangeDeathSceneSaveDelay(4.0);
    verifyInOrder([() => configRepository.setDeathSceneSaveDelay(4.0)]);
  });
}
