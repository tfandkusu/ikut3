import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_state_notifier.dart';

void main() {
  test("HomeUiModelStateNotifier", () {
    final container = ProviderContainer();
    final stateNotifier =
        container.read(homeUiModelStateNotifierProvider.notifier);
    getState() => container.read(homeUiModelStateNotifierProvider);
    expect(getState(),
        const HomeUiModel(logs: [], videoStatus: HomeVideoStatus.initial));
    stateNotifier.onConnectingCamera();
    expect(getState(),
        const HomeUiModel(logs: [], videoStatus: HomeVideoStatus.connecting));
    stateNotifier.onCameraStart();
    expect(getState(),
        const HomeUiModel(logs: [], videoStatus: HomeVideoStatus.start));
  });
}
