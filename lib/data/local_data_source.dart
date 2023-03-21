import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  static const _keyCameraHasConnected = "cameraHasConnected";

  Future<void> setCameraHasConnected(bool cameraHasConnected) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCameraHasConnected, cameraHasConnected);
  }

  Future<bool> isCameraHasConnected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCameraHasConnected) ?? false;
  }
}

final localDataSourceProvider = Provider((_) => LocalDataSource());
