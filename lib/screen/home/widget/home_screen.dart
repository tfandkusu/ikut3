import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/web_socket_provider.dart';
import 'package:ikut3/screen/home/stateholder/home_event_handler.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_provider.dart';

import '../../../resource/strings.dart';
import 'about_dialog.dart';
import 'footer_widget.dart';
import 'home_log_widget.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final uiModel = ref.watch(homeUiModelProvider);
    final eventHandler = ref.read(homeEventHandlerProvider);
    useEffect(() {
      eventHandler.onCreate();
      return () {};
    }, []);
    // 横幅を取得
    final width = MediaQuery.of(context).size.width;
    // コンテンツ横幅を計算
    double contentWidth = 600;
    if (width < contentWidth) {
      contentWidth = width;
    }
    // ビデオ縦幅を計算
    double videoHeight = 9 * contentWidth / 16;
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
            Center(
              child: SizedBox(
                  width: contentWidth,
                  height: videoHeight,
                  child: const HtmlElementView(viewType: "video")),
            ),
            const SizedBox(height: 16),
            Expanded(
                child: Container(
              width: contentWidth,
              decoration: BoxDecoration(
                  border: Border.all(color: themeData.colorScheme.outline)),
              child: ListView.builder(
                  itemBuilder: (_, index) {
                    final log = uiModel.logs[index];
                    return HomeLogWidget(log);
                  },
                  itemCount: uiModel.logs.length),
            )),
            const SizedBox(height: 16),
            const FooterWidget()
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
