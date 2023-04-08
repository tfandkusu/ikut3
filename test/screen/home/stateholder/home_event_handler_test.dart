import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/data/local_data_source.dart';
import 'package:ikut3/data/web_socket_connection_state_notifier.dart';
import 'package:ikut3/model/web_socket_connection_status.dart';
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
  final stateNotifier = MockIkutLogListStateNotifier();
  final currentTimeGetter = MockCurrentTimeGetter();
  final homeUiModelStateNotifier = MockHomeUiModelStateNotifier();
  final localDataSource = MockLocalDataSource();
  final webSocketConnectionStateNotifier = WebSocketConnectionStateNotifier();
  test('HomeEventHandler#onCreate カメラの許可をまだ出していない。', () async {
    when(() => localDataSource.isCameraHasStarted()).thenAnswer((_) async {
      return false;
    });
    when(() => onCreateUseCase.execute()).thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      homeOnCreateUseCase.overrideWithValue(onCreateUseCase),
      localDataSourceProvider.overrideWithValue(localDataSource)
    ]);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onCreate();
    verifyInOrder([
      () => localDataSource.isCameraHasStarted(),
      () => onCreateUseCase.execute()
    ]);
  });
  test('HomeEventHandler#onCreate カメラの許可を以前の起動時に行っている', () async {
    when(() => localDataSource.isCameraHasStarted()).thenAnswer((_) async {
      return true;
    });
    when(() => onCreateUseCase.execute()).thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      homeOnCreateUseCase.overrideWithValue(onCreateUseCase),
      homeUiModelStateNotifierProvider
          .overrideWith((ref) => homeUiModelStateNotifier),
      localDataSourceProvider.overrideWithValue(localDataSource)
    ]);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onCreate();
    verifyInOrder([
      () => localDataSource.isCameraHasStarted(),
      () => homeUiModelStateNotifier.onConnectingCamera(),
      () => onCreateUseCase.execute()
    ]);
  });
  test('HomeEventHandler#onCameraStart', () {
    final now = DateTime.now();
    when(() => localDataSource.setCameraHasStarted(true))
        .thenAnswer((_) async {});
    final container = ProviderContainer(overrides: [
      ikutLogListStateNotifierProvider.overrideWith((ref) => stateNotifier),
      currentTimeGetterProvider.overrideWithValue(currentTimeGetter),
      homeUiModelStateNotifierProvider
          .overrideWith((ref) => homeUiModelStateNotifier),
      localDataSourceProvider.overrideWithValue(localDataSource)
    ]);
    when(() => currentTimeGetter.get()).thenReturn(now);
    final eventHandler = container.read(homeEventHandlerProvider);
    eventHandler.onCameraStart();
    verifyInOrder([
      () => localDataSource.setCameraHasStarted(true),
      () => homeUiModelStateNotifier.onCameraStart(),
      () => currentTimeGetter.get(),
      () => stateNotifier.onCameraStart(now)
    ]);
  });
  test('HomeEventHandler#onClickConnectCamera', () {
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
      webSocketConnectionStateNotifierProvider
          .overrideWith((ref) => webSocketConnectionStateNotifier),
    ]);
    when(() => currentTimeGetter.get()).thenReturn(now);
    final eventHandler = container.read(homeEventHandlerProvider);
    eventHandler.onClickConnect();
    verifyInOrder([
      () => webSocketConnectionStateNotifier
          .setStatus(WebSocketConnectionStatus.progress)
    ]);
  });
}
