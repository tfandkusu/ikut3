import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/screen/home/widget/home_death_scene_save_delay_widget.dart';
import 'package:sprintf/sprintf.dart';

import '../../../resource/strings.dart';
import '../stateholder/home_event_handler.dart';
import '../stateholder/home_ui_model_provider.dart';

/// ホーム画面のシーン設定部分
class HomeSceneWidget extends HookConsumerWidget {
  final double _contentWidth;

  const HomeSceneWidget(this._contentWidth, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final uiModel = ref.watch(homeUiModelProvider);
    // ignore: unused_local_variable
    final eventHandler = ref.read(homeEventHandlerProvider);
    final keyStyle = themeData.typography.dense.bodyMedium?.copyWith(
        color: themeData.colorScheme.onSurface, fontWeight: FontWeight.bold);
    final valueStyle = themeData.typography.englishLike.bodyMedium
        ?.copyWith(color: themeData.colorScheme.onSurfaceVariant);
    return Center(
      child: SizedBox(
        width: _contentWidth + 36,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            Text(Strings.saveScene, style: keyStyle),
            const SizedBox(width: 16),
            // _buildCheckBox(
            //     context,
            //     Strings.sceneKill,
            //     uiModel.config.saveWhenKillScene,
            //     Strings.sceneKillTooltip, (value) {
            //   eventHandler.onChangeSaveWhenKillScene(value);
            // }),
            // _buildCheckBox(context, Strings.sceneDeath,
            //     uiModel.config.saveWhenDeathScene, null, (value) {
            //   eventHandler.onChangeSaveWhenDeathScene(value);
            // }),
            Text(Strings.sceneDeath, style: valueStyle),
            Visibility(
              visible: uiModel.config.saveWhenDeathScene,
              child: Tooltip(
                message: Strings.saveDelayTooltip,
                child: TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) =>
                              const HomeDeathSceneSaveDelayWidget());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(sprintf(
                        Strings.saveDelay,
                        [uiModel.config.deathSceneSaveDelay.toInt()],
                      )),
                    )),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildCheckBox(BuildContext context, String text, bool value,
      String? tooltipText, Function(bool) onChanged) {
    final themeData = Theme.of(context);
    final valueStyle = themeData.typography.englishLike.bodyMedium
        ?.copyWith(color: themeData.colorScheme.onSurfaceVariant);
    final inkWell = InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                value: value,
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                }),
            const SizedBox(width: 4),
            Text(text, style: valueStyle),
          ],
        ),
      ),
    );
    if (tooltipText != null) {
      return Tooltip(
        message: tooltipText,
        child: inkWell,
      );
    } else {
      return inkWell;
    }
  }
}
