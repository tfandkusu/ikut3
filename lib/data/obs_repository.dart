import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/websocket/obs_send_message_data.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'websocket/obs_send_message.dart';

/// OBSを操作する担当Repository
class ObsRepository {
  final _uuid = const Uuid();

  WebSocketChannel? _webSocketChannel;

  void setWebSocketChannel(WebSocketChannel? webSocketChannel) {
    _webSocketChannel = webSocketChannel;
  }

  bool isConnected() {
    return _webSocketChannel != null;
  }

  void getReplayBufferStatus() {
    final sendMessage = ObsSendMessage(
        op: 6,
        d: ObsSendMessageData.request(
            requestType: "GetReplayBufferStatus", requestId: _uuid.v4()));
    final sendMessageString = json.encode(sendMessage.toJson());
    _webSocketChannel?.sink.add(sendMessageString);
  }

  void saveReplayBuffer() {
    final sendMessage = ObsSendMessage(
        op: 6,
        d: ObsSendMessageData.request(
            requestType: "SaveReplayBuffer", requestId: _uuid.v4()));
    final sendMessageString = json.encode(sendMessage.toJson());
    _webSocketChannel?.sink.add(sendMessageString);
  }
}

final obsRepositoryProvider = Provider((ref) {
  return ObsRepository();
});
