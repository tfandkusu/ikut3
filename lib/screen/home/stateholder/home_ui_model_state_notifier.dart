import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model.dart';

class HomeUiModelStateNotifier extends StateNotifier<HomeUiModel> {
  HomeUiModelStateNotifier() : super(const HomeUiModel(logs: []));
}

final homeUiModelStateNotifierProvider =
    StateNotifierProvider<HomeUiModelStateNotifier, HomeUiModel>(
        (ref) => HomeUiModelStateNotifier());
