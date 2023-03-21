import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test("LocalDataStore", () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();

    final localDataSource = container.read(localDataSourceProvider);
    expect(await localDataSource.isCameraHasConnected(), false);
    await localDataSource.setCameraHasConnected(true);
    expect(await localDataSource.isCameraHasConnected(), true);
    await localDataSource.setCameraHasConnected(false);
    expect(await localDataSource.isCameraHasConnected(), false);
  });
}
