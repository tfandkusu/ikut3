import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ikut3/model/web_socket_connection_status.dart';

part 'web_socket_connection.freezed.dart';

@freezed
class WebSocketConnection with _$WebSocketConnection {
  const factory WebSocketConnection(
      {required String host,
      required int port,
      required WebSocketConnectionStatus status}) = _WebSocketConnection;
}
