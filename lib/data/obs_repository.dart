import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/obs_message_data.dart';
import '../model/obs_send_message.dart';

/// OBSを操作する担当Repository
class ObsRepository {
  final _uuid = const Uuid();

  WebSocketChannel? _webSocketChannel;

  void setWebSocketChannel(WebSocketChannel? webSocketChannel) {
    _webSocketChannel = webSocketChannel;
  }

  void saveReplayBuffer() {
    final sendMessage = ObsSendMessage(
        op: 6,
        d: ObsMessageData.request(
            requestType: "SaveReplayBuffer", requestId: _uuid.v4()));
    final sendMessageString = json.encode(sendMessage.toJson());
    _webSocketChannel?.sink.add(sendMessageString);
  }
}

final obsRepositoryProvider = Provider((ref) {
  return ObsRepository();
});
