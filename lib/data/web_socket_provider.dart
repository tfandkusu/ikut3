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
  final obsRepository = ref.read(obsRepositoryProvider);
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
      // 最初の挨拶
      const sendMessage =
          ObsSendMessage(op: 1, d: ObsSendMessageData.identify(rpcVersion: 1));
      final sendMessageString = json.encode(sendMessage.toJson());
      channel.sink.add(sendMessageString);
    } else if (receiveMessage.op == 2) {
      // 疎通完了
      logStateNotifier.onConnected(currentTimeGetter.get());
      homeEventHandler.onConnected();
      obsRepository.setWebSocketChannel(channel);
      obsRepository.getReplayBufferStatus();
    } else if (receiveMessage.op == 5) {
      // OBSで発生したイベント
      final eventType = receiveMessage.d.eventType;
      if (eventType == 'ReplayBufferSaved') {
        // リプレイバッファ保存が完了
        final path = receiveMessage.d.eventData?.savedReplayPath;
        if (path != null) {
          logStateNotifier.onReplayBufferSaved(currentTimeGetter.get(), path);
        }
      } else if (eventType == "ReplayBufferStateChanged") {
        // リプレイバッファの開始または停止
        final outputActive = receiveMessage.d.eventData?.outputActive;
        final outputState = receiveMessage.d.eventData?.outputState;
        if (outputActive == true) {
          // 開始された
          logStateNotifier.onReplayBufferIsStarted(currentTimeGetter.get());
        } else if (outputState == "OBS_WEBSOCKET_OUTPUT_STOPPING") {
          // 停止された
          logStateNotifier.onReplayBufferIsStopped(currentTimeGetter.get());
        }
      }
    } else if (receiveMessage.op == 7) {
      // リクエストに対する返答
      if (receiveMessage.d.requestType == "GetReplayBufferStatus") {
        if (receiveMessage.d.responseData?.outputActive == false) {
          logStateNotifier.onReplayBufferHasNotStarted(currentTimeGetter.get());
        } else if (receiveMessage.d.responseData == null) {
          logStateNotifier.onReplayBufferIsDisabled(currentTimeGetter.get());
        }
      }
    }
  }, onError: (error) {
    homeEventHandler.onConnectError();
    obsRepository.setWebSocketChannel(null);
  }, onDone: () {
    homeEventHandler.onConnectError();
    obsRepository.setWebSocketChannel(null);
  });
  return 0;
});
