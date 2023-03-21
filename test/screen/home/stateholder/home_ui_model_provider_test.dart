import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/model/ikut_log.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_provider.dart';

void main() {
  test('test homeUiModelProvider', () {
    final dateTime = DateTime.now();
    final logs = [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.cameraStart(dateTime: dateTime.copyWith(second: 1)),
      IkutLog.saveReplayBuffer(dateTime: dateTime.copyWith(second: 1))
    ];

    final container = ProviderContainer(overrides: [
      ikutLogListStateNotifierProvider
          .overrideWith((ref) => IkutLogListStateNotifier.override(logs))
    ]);
    getUiModel() => container.read(homeUiModelProvider);
    expect(getUiModel(), HomeUiModel(logs: logs));
  });
}
