import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/model/obs_message_data.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/obs_receive_message.dart';
import '../model/obs_send_message.dart';

final webSocketProvider = Provider.autoDispose((ref) {
  // プロトコル
  // https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md
  // const uuid = Uuid();
  final wsUrl = Uri.parse('ws://localhost:4455');
  // TODO 接続エラー、途中切断
  final channel = WebSocketChannel.connect(wsUrl);
  ref.onDispose(() {
    channel.sink.close();
  });
  channel.stream.listen((receiveMessageString) {
    final receiveMessage =
        ObsReceiveMessage.fromJson(json.decode(receiveMessageString));
    if (receiveMessage.op == 0) {
      const sendMessage =
          ObsSendMessage(op: 1, d: ObsMessageData.identify(rpcVersion: 1));
      final sendMessageString = json.encode(sendMessage.toJson());
      channel.sink.add(sendMessageString);
    } else if (receiveMessage.op == 2) {
      // TODO リプレイバッファ保存が送れる
      // final sendMessage = ObsSendMessage(
      //     op: 6,
      //     d: ObsMessageData.request(
      //         requestType: "SaveReplayBuffer", requestId: uuid.v4()));
      // final sendMessageString = json.encode(sendMessage.toJson());
      // channel.sink.add(sendMessageString);
      // print(sendMessageString);
    }
  });

  return "test";
});
