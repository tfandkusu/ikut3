import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/data/local_data_source.dart';
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

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockWebSocketConnectionStateNotifier extends Mock
    implements WebSocketConnectionStateNotifier {}

void main() {
  final onCreateUseCase = MockHomeOnCreateUseCase();
  final logListStateNotifier = MockIkutLogListStateNotifier();
  final currentTimeGetter = MockCurrentTimeGetter();
  final homeUiModelStateNotifier = MockHomeUiModelStateNotifier();
  final localDataSource = MockLocalDataSource();
  final webSocketConnectionStateNotifier = WebSocketConnectionStateNotifier();
  test('HomeEventHandler#onCreate カメラの許可をまだ出していない。obs-websocketに自動接続しない。',
      () async {
    final now = DateTime.now();
    when(() => currentTimeGetter.get()).thenReturn(now);
    when(() => localDataSource.isCameraHasStarted()).thenAnswer((_) async {
      return false;
    });
    when(() => localDataSource.isConnected()).thenAnswer((_) async {
      return false;
    });
    when(() => onCreateUseCase.execute()).thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      currentTimeGetterProvider.overrideWithValue(currentTimeGetter),
      ikutLogListStateNotifierProvider
          .overrideWith((ref) => logListStateNotifier),
      homeOnCreateUseCase.overrideWithValue(onCreateUseCase),
      localDataSourceProvider.overrideWithValue(localDataSource)
    ]);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onCreate();
    verifyInOrder([
      () => logListStateNotifier.onAppStart(now),
      () => localDataSource.isCameraHasStarted(),
      () => localDataSource.isConnected(),
      () => onCreateUseCase.execute()
    ]);
  });
  test('HomeEventHandler#onCreate カメラの許可を以前の起動時に行っている。obs-websocketに自動接続する。',
      () async {
    final now = DateTime.now();
    when(() => localDataSource.isCameraHasStarted()).thenAnswer((_) async {
      return true;
    });
    when(() => localDataSource.isConnected()).thenAnswer((_) async {
      return true;
    });
    when(() => onCreateUseCase.execute()).thenAnswer((_) async {});
    when(() => currentTimeGetter.get()).thenReturn(now);
    final container = ProviderContainer(overrides: [
      homeOnCreateUseCase.overrideWithValue(onCreateUseCase),
      homeUiModelStateNotifierProvider
          .overrideWith((ref) => homeUiModelStateNotifier),
      localDataSourceProvider.overrideWithValue(localDataSource),
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
      () => localDataSource.isCameraHasStarted(),
      () => homeUiModelStateNotifier.onConnectingCamera(),
      () => localDataSource.isConnected(),
      () => logListStateNotifier.onStartConnect(now),
      () => webSocketConnectionStateNotifier.setConnect(true),
      () => onCreateUseCase.execute()
    ]);
  });
  test('HomeEventHandler#onCameraStart', () async {
    final now = DateTime.now();
    when(() => localDataSource.setCameraHasStarted(true))
        .thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      ikutLogListStateNotifierProvider
          .overrideWith((ref) => logListStateNotifier),
      currentTimeGetterProvider.overrideWithValue(currentTimeGetter),
      homeUiModelStateNotifierProvider
          .overrideWith((ref) => homeUiModelStateNotifier),
      localDataSourceProvider.overrideWithValue(localDataSource)
    ]);
    when(() => currentTimeGetter.get()).thenReturn(now);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onCameraStart();
    verifyInOrder([
      () => homeUiModelStateNotifier.onCameraStart(),
      () => currentTimeGetter.get(),
      () => logListStateNotifier.onCameraStart(now),
      () => localDataSource.setCameraHasStarted(true),
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
    when(() => localDataSource.setConnected(true)).thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      homeUiModelStateNotifierProvider
          .overrideWith((ref) => homeUiModelStateNotifier),
      localDataSourceProvider.overrideWithValue(localDataSource)
    ]);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onConnected();
    verifyInOrder([
      () => homeUiModelStateNotifier.onConnected(),
      () => localDataSource.setConnected(true)
    ]);
  });

  test('HomeEventHandler#onConnectError', () async {
    when(() => localDataSource.setConnected(false)).thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      currentTimeGetterProvider.overrideWithValue(currentTimeGetter),
      ikutLogListStateNotifierProvider
          .overrideWith((ref) => logListStateNotifier),
      homeUiModelStateNotifierProvider
          .overrideWith((ref) => homeUiModelStateNotifier),
      localDataSourceProvider.overrideWithValue(localDataSource)
    ]);
    final now = DateTime.now();
    when(() => currentTimeGetter.get()).thenReturn(now);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onConnectError();
    verifyInOrder([
      () => currentTimeGetter.get(),
      () => logListStateNotifier.onConnectError(now),
      () => homeUiModelStateNotifier.onConnectError(),
      () => localDataSource.setConnected(false)
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
}
