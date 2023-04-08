import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/model/web_socket_connection.dart';
import 'package:ikut3/model/web_socket_connection_status.dart';

class WebSocketConnectionStateNotifier
    extends StateNotifier<WebSocketConnection> {
  WebSocketConnectionStateNotifier()
      : super(const WebSocketConnection(
          host: 'localhost',
          port: 4545,
          status: WebSocketConnectionStatus.disconnect,
        ));

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
