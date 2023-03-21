import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/screen/home/stateholder/home_event_handler.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_state_notifier.dart';
import 'package:ikut3/screen/home/usecase/home_on_create_use_case.dart';
import 'package:ikut3/util/current_time_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeOnCreateUseCase extends Mock implements HomeOnCreateUseCase {}

class MockIkutLogListStateNotifier extends Mock
    implements IkutLogListStateNotifier {}

class MockCurrentTimeGetter extends Mock implements CurrentTimeGetter {}

class MockHomeUiModelStateNotifier extends Mock implements HomeUiModelStateNotifier {}

void main() {
  final onCreateUseCase = MockHomeOnCreateUseCase();
  final stateNotifier = MockIkutLogListStateNotifier();
  final currentTimeGetter = MockCurrentTimeGetter();
  final homeUiModelStateNotifier =
      MockHomeUiModelStateNotifier();
  test('HomeEventHandler#onCreate', () async {
    when(() => onCreateUseCase.execute()).thenAnswer((_) async {});
    final container = ProviderContainer(
        overrides: [homeOnCreateUseCase.overrideWithValue(onCreateUseCase)]);
    final eventHandler = container.read(homeEventHandlerProvider);
    await eventHandler.onCreate();
    verifyInOrder([() => onCreateUseCase.execute()]);
  });
  test('HomeEventHandler#onCameraStart', () {
    final now = DateTime.now();
    final container = ProviderContainer(overrides: [
      ikutLogListStateNotifierProvider.overrideWith((ref) => stateNotifier),
      currentTimeGetterProvider.overrideWithValue(currentTimeGetter)
    ]);
    when(() => currentTimeGetter.get()).thenReturn(now);
    final eventHandler = container.read(homeEventHandlerProvider);
    eventHandler.onCameraStart();
    verifyInOrder([
      () => currentTimeGetter.get(),
      () => stateNotifier.onCameraStart(now)
    ]);
  });
  test('HomeEventHandler#onClickConnectCamera', () {
    final now = DateTime.now();
    final container = ProviderContainer(overrides: [
      homeUiModelStateNotifierProvider.overrideWith((ref) => homeUiModelStateNotifier),
    ]);
    when(() => currentTimeGetter.get()).thenReturn(now);
    final eventHandler = container.read(homeEventHandlerProvider);
    eventHandler.onClickConnectCamera();
    verifyInOrder([
      () => homeUiModelStateNotifier.onConnectCamera()
    ]);
  });
}
