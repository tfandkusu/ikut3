import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/model/web_socket_connection.dart';
import 'package:ikut3/model/web_socket_connection_status.dart';

import 'local_data_source.dart';

class WebSocketConnectionStateNotifier
    extends StateNotifier<WebSocketConnection> {
  WebSocketConnectionStateNotifier()
      : super(const WebSocketConnection(
          host: LocalDataSource.defaultHost,
          port: LocalDataSource.defaultPort,
          status: WebSocketConnectionStatus.disconnect,
        ));

  WebSocketConnectionStateNotifier.override(WebSocketConnection connection)
      : super(connection);

  void setHostAndPort(String host, int port) {
    state = state.copyWith(host: host, port: port);
  }

  void setStatus(WebSocketConnectionStatus status) {
    state = state.copyWith(status: status);
  }
}

final webSocketConnectionStateNotifierProvider = StateNotifierProvider<
    WebSocketConnectionStateNotifier,
    WebSocketConnection>((ref) => WebSocketConnectionStateNotifier());
