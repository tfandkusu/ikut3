import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_socket_connection.freezed.dart';

@freezed
class WebSocketConnection with _$WebSocketConnection {
  const factory WebSocketConnection(
      {required String host,
      required int port,
      required bool connect}) = _WebSocketConnection;
}
