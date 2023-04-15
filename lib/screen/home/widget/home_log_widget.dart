import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/ikut_log.dart';
import '../../../resource/log_strings.dart';

class HomeLogWidget extends StatelessWidget {
  final IkutLog _log;

  const HomeLogWidget(this._log, {super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final format = DateFormat('MM/dd HH:mm:ss');
    final timeString = format.format(_log.dateTime);
    final eventString = _log.when(
      appStart: (_) => LogStrings.appStart,
      cameraStart: (_) => LogStrings.cameraStart,
      saveReplayBuffer: (_) => LogStrings.saveReplayBuffer,
      replayBufferSaved: (_, uriString) => LogStrings.replayBufferSaved,
      connecting: (_) => LogStrings.connecting,
      connected: (_) => LogStrings.connected,
      connectError: (_) => LogStrings.connectError,
    );
    final timeTextStyle = themeData.typography.dense.bodyMedium?.copyWith(
        color: themeData.colorScheme.onSurfaceVariant,
        fontFeatures: [const FontFeature.tabularFigures()]);
    final eventTextStyle = themeData.typography.dense.bodyMedium
        ?.copyWith(color: themeData.colorScheme.onSurface);
    final errorTextStyle = themeData.typography.dense.bodyMedium
        ?.copyWith(color: themeData.colorScheme.secondary);
    final pathTextStyle = themeData.typography.englishLike.bodySmall
        ?.copyWith(color: themeData.colorScheme.onSurfaceVariant);
    final rowChildren = <Widget>[];
    rowChildren.add(Text(timeString, style: timeTextStyle));
    rowChildren.add(const SizedBox(width: 16));
    _log.maybeWhen(replayBufferSaved: (dateTime, uriString) {
      // 保存完了ケース
      rowChildren.add(Text(
        eventString,
        style: eventTextStyle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ));
      rowChildren.add(const SizedBox(width: 8));
      rowChildren.add(Expanded(
          child: Text(uriString,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: pathTextStyle)));
    }, connectError: (dateTime) {
      rowChildren.add(Expanded(
        child: Text(
          eventString,
          style: errorTextStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ));
    }, orElse: () {
      // それ以外ケース
      rowChildren.add(Expanded(
        child: Text(
          eventString,
          style: eventTextStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ));
    });
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: rowChildren,
      ),
    );
  }
}
