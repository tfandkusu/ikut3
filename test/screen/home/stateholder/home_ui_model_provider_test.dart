import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_config_state_notifier.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/data/local_data_source.dart';
import 'package:ikut3/data/web_socket_connection_state_notifier.dart';
import 'package:ikut3/model/ikut_config.dart';
import 'package:ikut3/model/ikut_log.dart';
import 'package:ikut3/model/web_socket_connection.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_provider.dart';

void main() {
  test('homeUiModelProvider', () {
    final dateTime = DateTime.now();
    final logs = [
      IkutLog.appStart(dateTime: dateTime.copyWith(second: 0)),
      IkutLog.cameraStart(dateTime: dateTime.copyWith(second: 1)),
      IkutLog.saveReplayBuffer(dateTime: dateTime.copyWith(second: 1))
    ];
    const connection = WebSocketConnection(
        host: LocalDataSource.defaultHost,
        port: LocalDataSource.defaultPort,
        connect: false);

    const config =
        IkutConfig(saveWhenKillScene: true, saveWhenDeathScene: false);

    final container = ProviderContainer(overrides: [
      ikutLogListStateNotifierProvider
          .overrideWith((ref) => IkutLogListStateNotifier.override(logs)),
      webSocketConnectionStateNotifierProvider.overrideWith(
          (ref) => WebSocketConnectionStateNotifier.override(connection)),
      ikutConfigStateNotifierProvider
          .overrideWith((ref) => IkutConfigStateNotifier.override(config))
    ]);
    getUiModel() => container.read(homeUiModelProvider);
    expect(
        getUiModel(),
        HomeUiModel(
            logs: logs,
            videoStatus: HomeVideoStatus.initial,
            connection: connection,
            connectStatus: HomeConnectStatus.progress,
            config: config));
  });
}
