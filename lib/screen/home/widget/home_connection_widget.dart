import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../resource/strings.dart';
import '../stateholder/home_ui_model_provider.dart';

class HomeConnectionWidget extends HookConsumerWidget {
  final double _contentWidth;

  const HomeConnectionWidget(this._contentWidth, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final uiModel = ref.watch(homeUiModelProvider);
    // final eventHandler = ref.read(homeEventHandlerProvider);
    final keyStyle = themeData.typography.dense.bodyMedium?.copyWith(
        color: themeData.colorScheme.onSurface, fontWeight: FontWeight.bold);
    final valueStyle = themeData.typography.englishLike.bodyMedium
        ?.copyWith(color: themeData.colorScheme.onSurfaceVariant);
    return Center(
      child: SizedBox(
        width: _contentWidth + 36,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
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
              const SizedBox(width: 16)
            ]),
      ),
    );
  }
}
