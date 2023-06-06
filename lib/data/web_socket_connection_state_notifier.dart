import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/config_repository.dart';
import 'package:ikut3/model/web_socket_connection.dart';

class WebSocketConnectionStateNotifier
    extends StateNotifier<WebSocketConnection> {
  WebSocketConnectionStateNotifier()
      : super(const WebSocketConnection(
            host: ConfigRepository.defaultHost,
            port: ConfigRepository.defaultPort,
            connect: false));

  WebSocketConnectionStateNotifier.override(WebSocketConnection connection)
      : super(connection);

  void setHostAndPort(String host, int port) {
    state = state.copyWith(host: host, port: port);
  }

  void setConnect(bool connect) {
    state = state.copyWith(connect: connect);
  }
}

final webSocketConnectionStateNotifierProvider = StateNotifierProvider<
    WebSocketConnectionStateNotifier,
    WebSocketConnection>((ref) => WebSocketConnectionStateNotifier());
