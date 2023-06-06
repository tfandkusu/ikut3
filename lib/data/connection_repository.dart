import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'local_data_source.dart';

/// 接続状況を管理するリポジトリ
class ConnectionRepository {
  final LocalDataSource _localDataSource;

  ConnectionRepository(this._localDataSource);

  Future<bool> isCameraHasStarted() {
    return _localDataSource.isCameraHasStarted();
  }

  Future<bool> isConnected() {
    return _localDataSource.isConnected();
  }

  Future<void> setCameraHasStarted(bool value) {
    return _localDataSource.setCameraHasStarted(value);
  }

  Future<void> setConnected(bool value) {
    return _localDataSource.setConnected(value);
  }
}

final connectionRepositoryProvider = Provider((ref) {
  return ConnectionRepository(ref.read(localDataSourceProvider));
});
