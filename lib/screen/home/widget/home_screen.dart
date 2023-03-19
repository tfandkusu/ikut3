import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/web_socket_provider.dart';

import '../../../resource/strings.dart';
import 'about_dialog.dart';
import 'footer_widget.dart';

class HomeStateNotifier extends StateNotifier<int> {
  HomeStateNotifier() : super(0);

  void increase() {
    state += 1;
  }
}

final homeStateNotifierProvider =
    StateNotifierProvider((ref) => HomeStateNotifier());

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 横幅を取得
    final width = MediaQuery.of(context).size.width;
    // ビデオ横幅を計算
    double videoWidth = 600;
    if (width < videoWidth) {
      videoWidth = width;
    }
    // ビデオ縦幅を計算
    double videoHeight = 9 * videoWidth / 16;
    // final state = ref.watch(homeStateNotifierProvider);

    // ignore: unused_local_variable
    final webSocket = ref.watch(webSocketProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_rounded),
              onPressed: () {
                showIkut3AboutDialog(context);
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                  width: videoWidth,
                  height: videoHeight,
                  child: const HtmlElementView(viewType: "video")),
            ),
            const SizedBox(height: 16),
            const FooterWidget()
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
