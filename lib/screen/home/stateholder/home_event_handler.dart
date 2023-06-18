import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/config_repository.dart';
import 'package:ikut3/data/connection_repository.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_state_notifier.dart';
import 'package:ikut3/util/current_time_provider.dart';

import '../../../data/web_socket_connection_state_notifier.dart';
import '../usecase/home_on_create_use_case.dart';

class HomeEventHandler {
  final HomeOnCreateUseCase _onCreateUseCase;

  final IkutLogListStateNotifier _logListStateNotifier;

  final CurrentTimeGetter _currentTimeGetter;

  final HomeUiModelStateNotifier _stateNotifier;

  final ConnectionRepository _connectionRepository;

  final ConfigRepository _configRepository;

  final WebSocketConnectionStateNotifier _connectionStateNotifier;

  HomeEventHandler(
      this._onCreateUseCase,
      this._logListStateNotifier,
      this._currentTimeGetter,
      this._stateNotifier,
      this._connectionRepository,
      this._configRepository,
      this._connectionStateNotifier);

  Future<void> onCreate() async {
    // ログ「起動しました」を追加。
    _logListStateNotifier.onAppStart(_currentTimeGetter.get());
    // 設定読み込み
    await _configRepository.load();
    // カメラ自動接続
    if (await _connectionRepository.isCameraHasStarted()) {
      onClickConnectCamera();
    }
    // obs-websocket 自動接続
    if (await _connectionRepository.isConnected()) {
      onClickConnect();
    }
    await _onCreateUseCase.execute();
  }

  Future<void> onCameraStart() async {
    _stateNotifier.onCameraStart();
    _logListStateNotifier.onCameraStart(_currentTimeGetter.get());
    await _connectionRepository.setCameraHasStarted(true);
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
  Future<void> onConnected() async {
    _stateNotifier.onConnected();
    await _connectionRepository.setConnected(true);
  }

  /// 接続エラー
  Future<void> onConnectError() async {
    _logListStateNotifier.onConnectError(_currentTimeGetter.get());
    _stateNotifier.onConnectError();
    await _connectionRepository.setConnected(false);
  }

  /// 接続エラーが確認された
  void onConnectErrorConfirmed() {
    _connectionStateNotifier.setConnect(false);
    _stateNotifier.resetConnectStatus();
  }

  /// たおしたチェック変更
  Future<void> onChangeSaveWhenKillScene(bool value) async {
    await _configRepository.setSaveWhenKillScene(value);
  }

  /// やられたチェック変更
  Future<void> onChangeSaveWhenDeathScene(bool value) async {
    await _configRepository.setSaveWhenDeathScene(value);
  }

  /// やられたシーンの保存遅延秒数の更新
  Future<void> onChangeDeathSceneSaveDelay(double value) async {
    await _configRepository.setDeathSceneSaveDelay(value);
  }
}

final homeEventHandlerProvider = Provider((ref) {
  return HomeEventHandler(
      ref.read(homeOnCreateUseCase),
      ref.read(ikutLogListStateNotifierProvider.notifier),
      ref.read(currentTimeGetterProvider),
      ref.read(homeUiModelStateNotifierProvider.notifier),
      ref.read(connectionRepositoryProvider),
      ref.read(configRepositoryProvider),
      ref.read(webSocketConnectionStateNotifierProvider.notifier));
});
