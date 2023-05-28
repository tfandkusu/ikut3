import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  /// 1度カメラが開始したので、次回は自動で開始する
  static const _keyCameraHasStarted = "cameraHasStarted";

  static const _keyWebSocketHost = "webSocketHost";

  static const _keyWebSocketPort = "webSocketPort";

  /// 1度接続成功したので、次回は自動接続する
  static const _keyConnected = "connected";

  static const defaultHost = "localhost";

  static const defaultPort = 4455;

  static const _keySaveWhenKillScene = "saveWhenKillScene";

  static const _keySaveWhenDeathScene = "saveWhenDeathScene";

  static const defaultSaveWhenKillScene = false;

  static const defaultSaveWhenDeathScene = true;

  Future<void> setCameraHasStarted(bool cameraHasConnected) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCameraHasStarted, cameraHasConnected);
  }

  Future<bool> isCameraHasStarted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCameraHasStarted) ?? false;
  }

  Future<void> setWebSocketHost(String webSocketHost) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWebSocketHost, webSocketHost);
  }

  Future<String> getWebSocketHost() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyWebSocketHost) ?? defaultHost;
  }

  Future<void> setWebSocketPort(int webSocketPort) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyWebSocketPort, webSocketPort);
  }

  Future<int> getWebSocketPort() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyWebSocketPort) ?? defaultPort;
  }

  Future<void> setConnected(bool connected) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyConnected, connected);
  }

  Future<bool> isConnected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyConnected) ?? false;
  }

  Future<void> setSaveWhenKillScene(bool saveWhenKillScene) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySaveWhenKillScene, saveWhenKillScene);
  }

  Future<bool> isSaveWhenKillScene() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySaveWhenKillScene) ?? defaultSaveWhenKillScene;
  }

  Future<void> setSaveWhenDeathScene(bool saveWhenDeathScene) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySaveWhenDeathScene, saveWhenDeathScene);
  }

  Future<bool> isSaveWhenDeathScene() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySaveWhenDeathScene) ?? defaultSaveWhenDeathScene;
  }
}

final localDataSourceProvider = Provider((_) => LocalDataSource());
