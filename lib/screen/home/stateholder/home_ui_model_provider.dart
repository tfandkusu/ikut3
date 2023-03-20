import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/ikut_log_list_state_notifier.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model.dart';

final homeUiModelProvider = Provider((ref) {
  final logs = ref.watch(ikutLogListStateNotifierProvider);
  return HomeUiModel(logs: logs);
});
