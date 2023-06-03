import 'package:flutter/material.dart';

import '../../../resource/strings.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final warningTextStyle = themeData.typography.dense.bodySmall
        ?.copyWith(color: themeData.colorScheme.onSurfaceVariant);
    return Column(children: [
      const Divider(height: 1, thickness: 1),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Strings.nintendoWarning1, style: warningTextStyle),
            Text(Strings.nintendoWarning2, style: warningTextStyle)
          ],
        ),
      ),
    ]);
  }
}
