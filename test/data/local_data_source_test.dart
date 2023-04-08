import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test("LocalDataStore", () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();

    final localDataSource = container.read(localDataSourceProvider);
    // デフォルト設定の確認
    expect(await localDataSource.isCameraHasStarted(), false);
    expect(await localDataSource.getWebSocketHost(), "localhost");
    expect(await localDataSource.getWebSocketPort(), 4455);
    // 保存の確認
    await localDataSource.setCameraHasStarted(true);
    expect(await localDataSource.isCameraHasStarted(), true);
    await localDataSource.setCameraHasStarted(false);
    expect(await localDataSource.isCameraHasStarted(), false);
    await localDataSource.setWebSocketHost("example.com");
    expect(await localDataSource.getWebSocketHost(), "example.com");
    await localDataSource.setWebSocketPort(4455);
    expect(await localDataSource.getWebSocketPort(), 4455);
  });
}
