import 'package:flutter/material.dart';
import 'package:ikut3/resource/privacy_strings.dart';
import 'package:ikut3/screen/home/widget/privacy_dialog.dart';

import '../../../resource/strings.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textStyle = themeData.typography.dense.bodySmall
        ?.copyWith(color: themeData.colorScheme.primary);
    final warningTextStyle = themeData.typography.dense.bodySmall
        ?.copyWith(color: themeData.colorScheme.onSurfaceVariant);
    return Column(children: [
      const Divider(height: 1, thickness: 1),
      const SizedBox(height: 8),
      TextButton(
          onPressed: () {
            showPrivacyDialog(context);
          },
          child: Text(PrivacyStrings.title, style: textStyle)),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
