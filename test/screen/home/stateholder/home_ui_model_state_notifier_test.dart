import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/config_repository.dart';
import 'package:ikut3/model/ikut_config.dart';
import 'package:ikut3/model/web_socket_connection.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_state_notifier.dart';

void main() {
  test("HomeUiModelStateNotifier", () {
    final container = ProviderContainer();
    final stateNotifier =
        container.read(homeUiModelStateNotifierProvider.notifier);
    getState() => container.read(homeUiModelStateNotifierProvider);
    expect(
        getState(),
        const HomeUiModel(
            logs: [],
            videoStatus: HomeVideoStatus.initial,
            connection: WebSocketConnection(
                host: ConfigRepository.defaultHost,
                port: ConfigRepository.defaultPort,
                connect: false),
            connectStatus: HomeConnectStatus.progress,
            config: IkutConfig(
                saveWhenKillScene: ConfigRepository.defaultSaveWhenKillScene,
                saveWhenDeathScene:
                    ConfigRepository.defaultSaveWhenDeathScene)));
    stateNotifier.onConnectingCamera();
    expect(
        getState(),
        const HomeUiModel(
            logs: [],
            videoStatus: HomeVideoStatus.connecting,
            connection: WebSocketConnection(
                host: ConfigRepository.defaultHost,
                port: ConfigRepository.defaultPort,
                connect: false),
            connectStatus: HomeConnectStatus.progress,
            config: IkutConfig(
                saveWhenKillScene: ConfigRepository.defaultSaveWhenKillScene,
                saveWhenDeathScene:
                    ConfigRepository.defaultSaveWhenDeathScene)));
    stateNotifier.onCameraStart();
    expect(
        getState(),
        const HomeUiModel(
            logs: [],
            videoStatus: HomeVideoStatus.start,
            connection: WebSocketConnection(
                host: ConfigRepository.defaultHost,
                port: ConfigRepository.defaultPort,
                connect: false),
            connectStatus: HomeConnectStatus.progress,
            config: IkutConfig(
                saveWhenKillScene: ConfigRepository.defaultSaveWhenKillScene,
                saveWhenDeathScene:
                    ConfigRepository.defaultSaveWhenDeathScene)));
    stateNotifier.onConnected();
    expect(
        getState(),
        const HomeUiModel(
            logs: [],
            videoStatus: HomeVideoStatus.start,
            connection: WebSocketConnection(
                host: ConfigRepository.defaultHost,
                port: ConfigRepository.defaultPort,
                connect: false),
            connectStatus: HomeConnectStatus.success,
            config: IkutConfig(
                saveWhenKillScene: ConfigRepository.defaultSaveWhenKillScene,
                saveWhenDeathScene:
                    ConfigRepository.defaultSaveWhenDeathScene)));
    stateNotifier.resetConnectStatus();
    expect(
        getState(),
        const HomeUiModel(
            logs: [],
            videoStatus: HomeVideoStatus.start,
            connection: WebSocketConnection(
                host: ConfigRepository.defaultHost,
                port: ConfigRepository.defaultPort,
                connect: false),
            connectStatus: HomeConnectStatus.progress,
            config: IkutConfig(
                saveWhenKillScene: ConfigRepository.defaultSaveWhenKillScene,
                saveWhenDeathScene:
                    ConfigRepository.defaultSaveWhenDeathScene)));
    stateNotifier.onConnectError();
    expect(
        getState(),
        const HomeUiModel(
            logs: [],
            videoStatus: HomeVideoStatus.start,
            connection: WebSocketConnection(
                host: ConfigRepository.defaultHost,
                port: ConfigRepository.defaultPort,
                connect: false),
            connectStatus: HomeConnectStatus.error,
            config: IkutConfig(
                saveWhenKillScene: ConfigRepository.defaultSaveWhenKillScene,
                saveWhenDeathScene:
                    ConfigRepository.defaultSaveWhenDeathScene)));
  });
}
