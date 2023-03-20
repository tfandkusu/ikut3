import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/obs_repository.dart';
import 'package:ikut3/screen/home/stateholder/home_event_handler.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_state_notifier.dart';
import 'package:ikut3/util/current_time_provider.dart';
import 'package:ikut3/util/prediction/predict.dart';
import 'package:ikut3/util/prediction/predict_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockPredict extends Mock implements Predict {}

class MockObsRepository extends Mock implements ObsRepository {}

class MockHomeUiModelStateNotifier extends Mock
    implements HomeUiModelStateNotifier {}

class MockCurrentTimeGetter extends Mock implements CurrentTimeGetter {}

void main() {
  final predict = MockPredict();
  final obsRepository = MockObsRepository();
  final stateNotifier = MockHomeUiModelStateNotifier();
  final currentTimeGetter = MockCurrentTimeGetter();
  test('test onCameraStart', () {
    final now = DateTime.now();
    final container = ProviderContainer(overrides: [
      predictProvider.overrideWithValue(predict),
      obsRepositoryProvider.overrideWithValue(obsRepository),
      homeUiModelStateNotifierProvider.overrideWith((ref) => stateNotifier),
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
}
