import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/data/obs_repository.dart';
import 'package:ikut3/data/web_socket_connection_state_notifier.dart';
import 'package:ikut3/data/websocket/obs_receive_message.dart';
import 'package:ikut3/data/websocket/obs_send_message_data.dart';
import 'package:ikut3/screen/home/stateholder/home_event_handler.dart';
import 'package:ikut3/util/current_time_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'websocket/obs_send_message.dart';

final webSocketProvider = Provider.autoDispose((ref) {
  final logStateNotifier = ref.read(ikutLogListStateNotifierProvider.notifier);
  final homeEventHandler = ref.read(homeEventHandlerProvider);
  final currentTimeGetter = ref.read(currentTimeGetterProvider);
  final connection = ref.watch(webSocketConnectionStateNotifierProvider);
  if (!connection.connect) {
    return 0;
  }
  // プロトコル
  // https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md
  // const uuid = Uuid();
  final wsUrl = Uri(scheme: "ws", host: connection.host, port: connection.port);
  final channel = WebSocketChannel.connect(wsUrl);
  ref.onDispose(() {
    final obsRepository = ref.read(obsRepositoryProvider);
    obsRepository.setWebSocketChannel(null);
    channel.sink.close();
  });
  channel.stream.listen((receiveMessageString) {
    final receiveMessage =
        ObsReceiveMessage.fromJson(json.decode(receiveMessageString));
    if (receiveMessage.op == 0) {
      const sendMessage =
          ObsSendMessage(op: 1, d: ObsSendMessageData.identify(rpcVersion: 1));
      final sendMessageString = json.encode(sendMessage.toJson());
      channel.sink.add(sendMessageString);
    } else if (receiveMessage.op == 2) {
      logStateNotifier.onConnected(currentTimeGetter.get());
      homeEventHandler.onConnected();
      final obsRepository = ref.read(obsRepositoryProvider);
      obsRepository.setWebSocketChannel(channel);
    } else if (receiveMessage.op == 5) {
      final eventType = receiveMessage.d.eventType;
      if (eventType == 'ReplayBufferSaved') {
        final path = receiveMessage.d.eventData?.savedReplayPath;
        if (path != null) {
          logStateNotifier.onReplayBufferSaved(currentTimeGetter.get(), path);
        }
      }
    }
  }, onError: (error) {
    homeEventHandler.onConnectError();
  });
  return 0;
});
