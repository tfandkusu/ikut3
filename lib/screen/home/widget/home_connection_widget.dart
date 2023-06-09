import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model.dart';
import 'package:ikut3/util/check_one_shot_operation.dart';

import '../../../resource/strings.dart';
import '../stateholder/home_event_handler.dart';
import '../stateholder/home_ui_model_provider.dart';

/// ホーム画面の接続情報部分
class HomeConnectionWidget extends HookConsumerWidget {
  final double _contentWidth;

  const HomeConnectionWidget(this._contentWidth, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final uiModel = ref.watch(homeUiModelProvider);
    final eventHandler = ref.read(homeEventHandlerProvider);
    final keyStyle = themeData.typography.dense.bodyMedium?.copyWith(
        color: themeData.colorScheme.onSurface, fontWeight: FontWeight.bold);
    final valueStyle = themeData.typography.englishLike.bodyMedium
        ?.copyWith(color: themeData.colorScheme.onSurfaceVariant);
    final messageStyle = themeData.typography.dense.bodyLarge
        ?.copyWith(color: themeData.colorScheme.secondary);
    // 接続エラーダイアログ表示
    ref.listen(homeUiModelProvider, (previous, next) {
      checkOneShotOperation(previous, next,
          (uiModel) => uiModel.connectStatus == HomeConnectStatus.error,
          (showError) {
        if (showError) {
          _showDialog(context, Strings.error, Strings.connectErrorMessage);
          eventHandler.onConnectErrorConfirmed();
        }
      });
    });

    String buttonText = Strings.connect;
    if (uiModel.connection.connect) {
      if (uiModel.connectStatus == HomeConnectStatus.progress) {
        buttonText = Strings.connecting;
      } else if (uiModel.connectStatus == HomeConnectStatus.success) {
        buttonText = Strings.connected;
      }
    }
    final buttonStyle = ButtonStyle(
        padding: MaterialStateProperty.resolveWith(
            (states) => const EdgeInsets.fromLTRB(32, 16, 32, 16)));
    return Center(
      child: SizedBox(
        width: _contentWidth + 36,
        child: Column(
          children: [
            Visibility(
              visible: !uiModel.connection.connect,
              child: Center(
                  child: Text(Strings.connectWebSocketMessage,
                      style: messageStyle)),
            ),
            Visibility(
                visible: !uiModel.connection.connect,
                child: const SizedBox(height: 8)),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const SizedBox(width: 16),
                  Text(Strings.host, style: keyStyle),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: _contentWidth / 4),
                      child: Text(
                        uiModel.connection.host,
                        style: valueStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                  const SizedBox(width: 16),
                  Text(Strings.port, style: keyStyle),
                  const SizedBox(width: 8),
                  Text(uiModel.connection.port.toString(), style: valueStyle),
                  const SizedBox(width: 8),
                  Tooltip(
                    message: Strings.connectionSettingMessage,
                    preferBelow: false,
                    child: IconButton(
                      icon: Icon(Icons.edit,
                          color: themeData.colorScheme.primary),
                      onPressed: () {
                        _showDialog(context, Strings.connectionSettingTitle,
                            Strings.connectionSettingMessage);
                      },
                    ),
                  ),
                  const SizedBox(width: 32),
                  FilledButton(
                      style: buttonStyle,
                      onPressed: uiModel.connection.connect
                          ? null
                          : () {
                              eventHandler.onClickConnect();
                            },
                      child: Text(buttonText))
                ]),
          ],
        ),
      ),
    );
  }

  /// ダイアログを表示する。
  void _showDialog(BuildContext context, String title, String message) {
    final themeData = Theme.of(context);
    final titleTextStyle = themeData.typography.dense.headlineMedium
        ?.copyWith(color: themeData.colorScheme.onSurface);
    final closeTextStyle = themeData.typography.dense.bodyMedium
        ?.copyWith(color: themeData.colorScheme.onPrimary);

    final buttonStyle = ButtonStyle(
        padding: MaterialStateProperty.resolveWith(
            (states) => const EdgeInsets.fromLTRB(32, 16, 32, 16)));

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title, style: titleTextStyle),
              content: Text(message),
              actions: [
                FilledButton(
                    style: buttonStyle,
                    onPressed: () {
                      // ダイアログを閉じる
                      Navigator.of(context).pop();
                    },
                    child: Text(Strings.ok, style: closeTextStyle))
              ],
            ));
  }
}
