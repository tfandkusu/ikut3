import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model.dart';

import '../../../resource/strings.dart';
import '../stateholder/home_event_handler.dart';
import '../stateholder/home_ui_model_provider.dart';

class HomeVideoWidget extends HookConsumerWidget {
  final double _width;

  const HomeVideoWidget(this._width, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final uiModel = ref.watch(homeUiModelProvider);
    final eventHandler = ref.read(homeEventHandlerProvider);
    final messageTextStyle = themeData.typography.dense.bodyLarge
        ?.copyWith(color: themeData.colorScheme.onSecondaryContainer);
    final buttonTextStyle = themeData.typography.dense.titleMedium
        ?.copyWith(color: themeData.colorScheme.onPrimary);
    final buttonStyle = ButtonStyle(
        padding: MaterialStateProperty.resolveWith(
            (states) => const EdgeInsets.all(24)));
    // ビデオ縦幅を計算
    double videoHeight = 9 * _width / 16;
    if (uiModel.videoStatus == HomeVideoStatus.initial) {
      return Center(
        child: SizedBox(
            width: _width,
            height: videoHeight,
            child: Container(
              color: themeData.colorScheme.secondaryContainer,
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Text(Strings.connectCameraMessage, style: messageTextStyle),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                      onPressed: () {
                        eventHandler.onClickConnectCamera();
                      },
                      icon: const Icon(Icons.videocam_rounded),
                      label: Text(Strings.connectCameraButton,
                          style: buttonTextStyle),
                      style: buttonStyle)
                ],
              ),
            )),
      );
    } else {
      return Center(
        child: SizedBox(
            width: _width,
            height: videoHeight,
            child: Stack(children: [
              const HtmlElementView(viewType: "video"),
              Visibility(
                  visible: uiModel.videoStatus == HomeVideoStatus.connecting,
                  child: Container(
                      color: themeData.colorScheme.secondaryContainer,
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          Text(Strings.connectingCameraMessage,
                              style: messageTextStyle),
                          const SizedBox(height: 32),
                          const CircularProgressIndicator()
                        ],
                      )))
            ])),
      );
    }
  }
}
