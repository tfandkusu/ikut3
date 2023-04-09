import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/web_socket_connection_state_notifier.dart';
import 'package:ikut3/model/web_socket_connection.dart';

void main() {
  test("webSocketConnectionStateNotifier", () {
    final container = ProviderContainer();
    final stateNotifier =
        container.read(webSocketConnectionStateNotifierProvider.notifier);
    getUiModel() => container.read(webSocketConnectionStateNotifierProvider);
    expect(
        getUiModel(),
        const WebSocketConnection(
            host: 'localhost', port: 4455, connect: false));
    stateNotifier.setHostAndPort('example.com', 1234);
    expect(
        getUiModel(),
        const WebSocketConnection(
            host: 'example.com', port: 1234, connect: false));
    stateNotifier.setConnect(true);
    expect(
        getUiModel(),
        const WebSocketConnection(
            host: 'example.com', port: 1234, connect: true));
  });
}
