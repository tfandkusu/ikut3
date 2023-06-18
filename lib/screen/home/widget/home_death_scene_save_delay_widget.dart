import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sprintf/sprintf.dart';

import '../../../data/config_repository.dart';
import '../../../resource/strings.dart';
import '../stateholder/home_event_handler.dart';
import '../stateholder/home_ui_model_provider.dart';

class HomeDeathSceneSaveDelayWidget extends HookConsumerWidget {
  const HomeDeathSceneSaveDelayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final uiModel = ref.watch(homeUiModelProvider);
    final config = uiModel.config;
    final eventHandler = ref.read(homeEventHandlerProvider);
    return AlertDialog(
      title: Text(Strings.saveDelayConfigTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            sprintf(Strings.saveDelayConfigMessage,
                [config.deathSceneSaveDelay.toInt()]),
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: themeData.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 36),
          Slider(
            value: uiModel.config.deathSceneSaveDelay,
            min: ConfigRepository.deathSceneSaveDelayMin,
            max: ConfigRepository.deathSceneSaveDelayMax,
            divisions: 4,
            onChanged: (value) {
              eventHandler.onChangeDeathSceneSaveDelay(value);
            },
            label:
                sprintf(Strings.seconds, [config.deathSceneSaveDelay.toInt()]),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(Strings.ok))
      ],
    );
  }
}
