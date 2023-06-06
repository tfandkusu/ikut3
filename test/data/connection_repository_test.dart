import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/connection_repository.dart';
import 'package:ikut3/data/local_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

void main() {
  final localDataSource = MockLocalDataSource();
  test("connectionRepository#setCameraHasStarted", () async {
    final container = ProviderContainer(
      overrides: [
        localDataSourceProvider.overrideWithValue(localDataSource),
      ],
    );
    when(() => localDataSource.setCameraHasStarted(true))
        .thenAnswer((_) async {});
    final repository = container.read(connectionRepositoryProvider);
    repository.setCameraHasStarted(true);
    verifyInOrder([
      () => localDataSource.setCameraHasStarted(true),
    ]);
  });

  test("connectionRepository#isConnected", () async {
    final container = ProviderContainer(
      overrides: [
        localDataSourceProvider.overrideWithValue(localDataSource),
      ],
    );
    when(() => localDataSource.isConnected()).thenAnswer((_) async {
      return true;
    });
    final repository = container.read(connectionRepositoryProvider);
    expect(true, await repository.isConnected());
    verifyInOrder([
      () => localDataSource.isConnected(),
    ]);
  });
  test("connectionRepository#setConnected", () async {
    final container = ProviderContainer(
      overrides: [
        localDataSourceProvider.overrideWithValue(localDataSource),
      ],
    );
    when(() => localDataSource.setConnected(true)).thenAnswer((_) async {});
    final repository = container.read(connectionRepositoryProvider);
    repository.setConnected(true);
    verifyInOrder([
      () => localDataSource.setConnected(true),
    ]);
  });

  test("connectionRepository#isCameraHasStarted", () async {
    final container = ProviderContainer(
      overrides: [
        localDataSourceProvider.overrideWithValue(localDataSource),
      ],
    );
    when(() => localDataSource.isCameraHasStarted()).thenAnswer((_) async {
      return true;
    });
    final repository = container.read(connectionRepositoryProvider);
    expect(true, await repository.isCameraHasStarted());
    verifyInOrder([
      () => localDataSource.isCameraHasStarted(),
    ]);
  });
}
