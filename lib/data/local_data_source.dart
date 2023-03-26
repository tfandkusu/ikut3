import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  static const _keyCameraHasStarted = "cameraHasStarted";

  Future<void> setCameraHasStarted(bool cameraHasConnected) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCameraHasStarted, cameraHasConnected);
  }

  Future<bool> isCameraHasStarted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCameraHasStarted) ?? false;
  }
}

final localDataSourceProvider = Provider((_) => LocalDataSource());
