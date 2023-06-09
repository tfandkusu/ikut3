import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/web_socket_provider.dart';
import 'package:ikut3/screen/home/stateholder/home_event_handler.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model_provider.dart';
import 'package:ikut3/screen/home/widget/home_video_widget.dart';
import 'package:ikut3/screen/home/widget/video_element.dart';
import 'package:ikut3/util/shims/dart_ui.dart' as ui;

import '../../../resource/strings.dart';
import 'about_dialog.dart';
import 'footer_widget.dart';
import 'home_connection_widget.dart';
import 'home_log_widget.dart';
import 'home_scene_widget.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final uiModel = ref.watch(homeUiModelProvider);
    final eventHandler = ref.read(homeEventHandlerProvider);
    // video要素を作成
    ui.platformViewRegistry.registerViewFactory('video', (viewId) {
      return getVideoElement(onCameraStart: () {
        eventHandler.onCameraStart();
      });
    });
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        eventHandler.onCreate();
      });
      return () {};
    }, []);
    // 横幅を取得
    final width = MediaQuery.of(context).size.width;
    // コンテンツ横幅を計算
    double contentWidth = 600;
    if (width < contentWidth) {
      contentWidth = width;
    }
    // スクロール制御
    // ログが追加されたら最下部にスクロールする。
    final scrollController = useScrollController();
    ref.listen(homeUiModelProvider, (previous, next) {
      if ((previous?.logs.length ?? 0) < next.logs.length) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
    });
    // ignore: unused_local_variable
    final webSocket = ref.watch(webSocketProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.title),
          elevation: 4,
          scrolledUnderElevation: 4,
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
            // ビデオ表示部分
            HomeVideoWidget(contentWidth),
            const SizedBox(height: 16),
            // WebSocket接続部分
            HomeConnectionWidget(contentWidth),
            // 抽出シーン設定
            HomeSceneWidget(contentWidth),
            const SizedBox(height: 8),
            // ログ表示部分
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
                itemCount: uiModel.logs.length,
                controller: scrollController,
                padding: const EdgeInsets.only(bottom: 48),
              ),
            )),
            const SizedBox(height: 16),
            // フッター部分
            const FooterWidget()
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
