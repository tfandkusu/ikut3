import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  static const _keyCameraHasStarted = "cameraHasStarted";

  static const _keyWebSocketHost = "webSocketHost";

  static const _keyWebSocketPort = "webSocketPort";

  static const defaultHost = "localhost";

  static const defaultPort = 4455;

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
}

final localDataSourceProvider = Provider((_) => LocalDataSource());
