import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/config_state_notifier.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/data/web_socket_connection_state_notifier.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_state_notifier.dart';

final homeUiModelProvider = Provider((ref) {
  final uiModel = ref.watch(homeUiModelStateNotifierProvider);
  final logs = ref.watch(ikutLogListStateNotifierProvider);
  final connection = ref.watch(webSocketConnectionStateNotifierProvider);
  final config = ref.watch(configStateNotifierProvider);
  return uiModel.copyWith(logs: logs, connection: connection, config: config);
});
