import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model.dart';

import '../../../data/local_data_source.dart';
import '../../../model/web_socket_connection.dart';
import '../../../model/web_socket_connection_status.dart';

class HomeUiModelStateNotifier extends StateNotifier<HomeUiModel> {
  HomeUiModelStateNotifier()
      : super(const HomeUiModel(
            logs: [],
            videoStatus: HomeVideoStatus.initial,
            connection: WebSocketConnection(
                host: LocalDataSource.defaultHost,
                port: LocalDataSource.defaultPort,
                status: WebSocketConnectionStatus.disconnect)));

  /// video要素を張った
  void onConnectingCamera() {
    state = state.copyWith(videoStatus: HomeVideoStatus.connecting);
  }

  /// カメラの取り込みが開始された
  void onCameraStart() {
    state = state.copyWith(videoStatus: HomeVideoStatus.start);
  }
}

final homeUiModelStateNotifierProvider =
    StateNotifierProvider<HomeUiModelStateNotifier, HomeUiModel>(
        (ref) => HomeUiModelStateNotifier());
