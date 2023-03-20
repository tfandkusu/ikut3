import 'package:flutter/material.dart';
import 'package:ikut3/screen/home/stateholder/home_ui_model.dart';
import 'package:intl/intl.dart';

import '../../../resource/log_strings.dart';

class HomeLogWidget extends StatelessWidget {
  final HomeUiModelLog _log;

  const HomeLogWidget(this._log, {super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final format = DateFormat('MM/dd HH:mm:ss');
    final timeString = format.format(_log.dateTime);
    final eventString = _log.when(appStart: (_) => LogStrings.appStart);
    final timeTextStyle = themeData.typography.dense.bodyMedium
        ?.copyWith(color: themeData.colorScheme.onSurfaceVariant);
    final eventTextStyle = themeData.typography.dense.bodyMedium
        ?.copyWith(color: themeData.colorScheme.onSurface);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 140, child: Text(timeString, style: timeTextStyle)),
          Expanded(
              child: Text(
            eventString,
            style: eventTextStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ))
        ],
      ),
    );
  }
}
