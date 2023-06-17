import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/config_repository.dart';
import 'package:ikut3/model/ikut_config.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model.dart';

import '../../../model/web_socket_connection.dart';

class HomeUiModelStateNotifier extends StateNotifier<HomeUiModel> {
  HomeUiModelStateNotifier()
      : super(const HomeUiModel(
            logs: [],
            videoStatus: HomeVideoStatus.initial,
            connection: WebSocketConnection(
                host: ConfigRepository.defaultHost,
                port: ConfigRepository.defaultPort,
                connect: false),
            connectStatus: HomeConnectStatus.progress,
            config: IkutConfig(
              saveWhenKillScene: ConfigRepository.defaultSaveWhenKillScene,
              saveWhenDeathScene: ConfigRepository.defaultSaveWhenDeathScene,
              deathSceneSaveDelay: ConfigRepository.defaultDeathSceneSaveDelay,
            )));

  /// video要素を張った
  void onConnectingCamera() {
    state = state.copyWith(videoStatus: HomeVideoStatus.connecting);
  }

  /// カメラの取り込みが開始された
  void onCameraStart() {
    state = state.copyWith(videoStatus: HomeVideoStatus.start);
  }

  /// 接続された
  void onConnected() {
    state = state.copyWith(connectStatus: HomeConnectStatus.success);
  }

  /// 接続エラー
  void onConnectError() {
    state = state.copyWith(connectStatus: HomeConnectStatus.error);
  }

  /// 接続中に戻す
  void resetConnectStatus() {
    state = state.copyWith(connectStatus: HomeConnectStatus.progress);
  }
}

final homeUiModelStateNotifierProvider =
    StateNotifierProvider<HomeUiModelStateNotifier, HomeUiModel>(
        (ref) => HomeUiModelStateNotifier());
