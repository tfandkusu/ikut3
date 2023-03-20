import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_state_notifier.dart';

final homeUiModelProvider = Provider((ref) {
  final homeUiModel = ref.watch(homeUiModelStateNotifierProvider);
  return homeUiModel;
});
