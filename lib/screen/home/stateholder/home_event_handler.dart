import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_state_notifier.dart';
import 'package:ikut3/util/current_time_provider.dart';

import '../../../data/local_data_source.dart';
import '../../../data/web_socket_connection_state_notifier.dart';
import '../usecase/home_on_create_use_case.dart';

class HomeEventHandler {
  final HomeOnCreateUseCase _onCreateUseCase;

  final IkutLogListStateNotifier _logListStateNotifier;

  final CurrentTimeGetter _currentTimeGetter;

  final HomeUiModelStateNotifier _stateNotifier;

  final LocalDataSource _localDataSource;

  final WebSocketConnectionStateNotifier _connectionStateNotifier;

  HomeEventHandler(
      this._onCreateUseCase,
      this._logListStateNotifier,
      this._currentTimeGetter,
      this._stateNotifier,
      this._localDataSource,
      this._connectionStateNotifier);

  Future<void> onCreate() async {
    if (await _localDataSource.isCameraHasStarted()) {
      onClickConnectCamera();
    }
    await _onCreateUseCase.execute();
  }

  Future<void> onCameraStart() async {
    _localDataSource.setCameraHasStarted(true);
    _stateNotifier.onCameraStart();
    _logListStateNotifier.onCameraStart(_currentTimeGetter.get());
  }

  void onClickConnectCamera() {
    _stateNotifier.onConnectingCamera();
  }

  /// 接続ボタンが押された
  void onClickConnect() {
    _logListStateNotifier.onStartConnect(_currentTimeGetter.get());
    _connectionStateNotifier.setConnect(true);
  }

  /// 接続された
  void onConnected() {
    _stateNotifier.onConnected();
  }

  /// 接続エラー
  void onConnectError() {
    _logListStateNotifier.onConnectError(_currentTimeGetter.get());
    _stateNotifier.onConnectError();
  }

  /// 接続エラーが確認された
  void onConnectErrorConfirmed() {
    _connectionStateNotifier.setConnect(false);
    _stateNotifier.resetConnectStatus();
  }
}

final homeEventHandlerProvider = Provider((ref) {
  return HomeEventHandler(
      ref.read(homeOnCreateUseCase),
      ref.read(ikutLogListStateNotifierProvider.notifier),
      ref.read(currentTimeGetterProvider),
      ref.read(homeUiModelStateNotifierProvider.notifier),
      ref.read(localDataSourceProvider),
      ref.read(webSocketConnectionStateNotifierProvider.notifier));
});
